import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:notebook_provider/models/enums.dart';
import 'package:path_provider/path_provider.dart';
import 'package:notebook_provider/models/book.dart';
import '../constant_values.dart';

class FirebaseModel extends ChangeNotifier {
  // to deal with personal books and nominations.
  String userId;

  // Firebase references and instances.
  Firestore _firestore = Firestore.instance;
  StorageReference _ref = FirebaseStorage.instance.ref();
  CollectionReference _reference = Firestore.instance.collection(Values.BOOKS);

  // Books' related variables
  bool _isLoading = false;
  Map<String, Book> _books = {};
  String _selectedBookId;

  // Download state
  bool downloadedOnce = false;

  // Constructor for getting the id of the user.
  FirebaseModel(String userId) {
    this.userId = userId;
  }

  // Get private variables.
  Map<String, Book> get books => _books;
  bool get isLoading => _isLoading;
  String get selectedBookId => _selectedBookId;
  Book get selectedBook => _books[_selectedBookId];

  // Set private variables.
  void set selectedBookId(String bookId) => _selectedBookId = bookId;
  void _setLoadingState(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  // Add books fetched from Firestore to our Map. (Caching)
  void addBooks(List<DocumentSnapshot> data) {
    data.forEach((element) {
      _books[element.documentID] =
          Book.fromMap(element.documentID, element.data, userId: userId);
    });
  }

  // Retrieve Stream of books depending on the mode.
  /// [All]: Retrieve all books.
  /// [MoreLike]: Retrieve suggested books (Requires a [type])
  /// [MostRecent]: Retrieve the most viewed books.
  /// [MostSelling]: Retrieve the most selled books.
  void getBooks() async {
    _setLoadingState(true);
    addBooks((await _reference.getDocuments()).documents);
    downloadedOnce = true;
    _setLoadingState(false);
  }

  // Retrieve users' personal books.
  dynamic getPersonalBooks() {
    Map<String, Book> personalBooks = {};
    _books.forEach((String key, Book value) {
      if (value.isReadBought || value.isListenBought)
        personalBooks[key] = value;
    });
    return personalBooks;
  }

  // Retrieve similar books to selected book, depending on TYPE.
  dynamic getSimilarBooks() {
    Map<String, Book> similarBooks = {};
    _books.forEach((String key, Book value) {
      if (key != _selectedBookId && value.type == selectedBook.type)
        similarBooks[key] = value;
    });
    return similarBooks;
  }

  // Retrieve the most viewed books.
  Map<String, Book> getMostRecentBooks() {
    var sortedKeys = _books.keys.toList(growable: false)
      ..sort((k1, k2) => _books[k2].viewCount.compareTo(_books[k1].viewCount));
    Map<String, Book> sortedMap =
        Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => _books[k]);
    return sortedMap;
  }

  // Retrieve the most selled books.
  Map<String, Book> getBestSellingBooks() {
    var sortedKeys = _books.keys.toList(growable: false)
      ..sort((k1, k2) => _books[k2].sellCount.compareTo(_books[k1].sellCount));
    Map<String, Book> sortedMap =
        Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => _books[k]);
    return sortedMap;
  }

  // Retrieve books givina  mode
  /// [mode]: specifies whether the retrieved books are All or Recent or BestSelling.
  Map<String, Book> getBooksByMode(ListMode mode) {
    if (mode == ListMode.All)
      return books;
    else if (mode == ListMode.MoreLike)
      return getSimilarBooks();
    else if (mode == ListMode.MostRecent)
      return getMostRecentBooks();
    else if (mode == ListMode.MostSelling)
      return getBestSellingBooks();
    else if (mode == ListMode.Liked) return getLikedBooks();
  }

  Map<String, Book> getLikedBooks() {
    Map<String, Book> likedBooks = {};
    _books.forEach((String key, Book value) {
      if (value.isFavorite) likedBooks[key] = value;
    });
    return likedBooks;
  }

  /// Retrieve books that match the givin [content]
  Map<String, Book> getMatchedBooks(String content) {
    Map<String, Book> matchedData = {};
    _books.forEach((String key, Book value) {
      if (value.title.contains(content)) matchedData[key] = value;
    });
    return matchedData;
  }

  // Toggle book's nominating (True|False)
  Future<void> toggleNomination() async {
    _setLoadingState(true);
    bool newValue = !_books[selectedBookId].isNominated;
    DocumentSnapshot data = await _firestore
        .collection(Values.BOOKS)
        .document(_selectedBookId)
        .snapshots()
        .first;
    // List of userIds' determines the nominating state
    // If the userId is not in the list, he doesn't nominate the book.
    Map<String, dynamic> nominations = data.data[Values.BOOK_NOMINATIONS];
    // User nominated the book, so we set userId to true.
    if (newValue) {
      _books[_selectedBookId].nominations++;
      nominations[userId] = true;
    }
    // User un-nominate the book, we remove the key.
    else {
      _books[_selectedBookId].nominations--;
      nominations.remove(userId);
    }
    // Update the new value.
    await _firestore
        .collection(Values.BOOKS)
        .document(_selectedBookId)
        .updateData({Values.BOOK_NOMINATIONS: nominations});
    // Make changes to local book.
    _books[_selectedBookId].isNominated = newValue;
    _setLoadingState(false);
  }

  // Toggle book's favorite (True|False)
  Future<void> toggleFavorite({String bookId}) async {
    // _setLoadingState(true);
    bool newValue = !_books[bookId ?? _selectedBookId].isFavorite;
    DocumentSnapshot data = await _firestore
        .collection(Values.BOOKS)
        .document(bookId ?? _selectedBookId)
        .snapshots()
        .first;

    /// [userId] state determines the favorite state of the book.
    // if the userId is a key in favorite list, the book is set to favorite.
    // if the userId is not a key, it is not a favorite book.
    Map<String, dynamic> favorite = data.data[Values.BOOK_FAVORITE];
    // User favorite the selected book.
    if (newValue)
      favorite[userId] = true;
    // User un-favorite the selected book.
    else
      favorite.remove(userId);
    // Update data inside firebase.
    await _firestore
        .collection(Values.BOOKS)
        .document(bookId ?? _selectedBookId)
        .updateData({Values.BOOK_FAVORITE: favorite});
    // Change state inside local book.
    _books[bookId ?? _selectedBookId].isFavorite =
        !_books[bookId ?? _selectedBookId].isFavorite;
    _setLoadingState(false);
  }

  /// Whenever a user views a book, increment its [viewCount].
  void incrementViews() {
    _firestore.collection(Values.BOOKS).document(_selectedBookId).updateData(
        {Values.BOOK_VIEW_COUNT: ++_books[_selectedBookId].viewCount});
  }

  /// Whenever a user sells a read/listen book, increment its [sellCount].
  // Needs fixes.
  void incrementSells() {
    _firestore.collection(Values.BOOKS).document(_selectedBookId).updateData(
        {Values.BOOK_SELL_COUNT: ++_books[_selectedBookId].sellCount});
  }

  // Buy selected book
  /// [mode] determines whether the book is bought as [Listen] or [Read]
  Future<void> buyBook(BuyMode mode) async {
    _setLoadingState(true);
    // Determine the updating value.
    String value = (mode == BuyMode.Read
        ? Values.BOOK_READ_BOUGHT
        : Values.BOOK_LISTEN_BOUGHT);
    // Getting sellCount from firestore.
    DocumentSnapshot data = await _firestore
        .collection(Values.BOOKS)
        .document(_selectedBookId)
        .snapshots()
        .first;
    int sellCount = data.data[Values.BOOK_SELL_COUNT];
    // Updating sellCount and user's id state to true.
    print(data.data);
    await _firestore
        .collection(Values.BOOKS)
        .document(_selectedBookId)
        .updateData({
      '${value}.$userId': true,
      Values.BOOK_SELL_COUNT: ++sellCount,
    });
    // Update sellCount locally.
    _books[_selectedBookId].sellCount = sellCount;
    if (mode == BuyMode.Read)
      _books[_selectedBookId].isReadBought = true;
    else
      _books[_selectedBookId].isListenBought = true;
    _saveBook();
    _setLoadingState(false);
  }

  // Adding selected book to user's personal books. (After buying it!)
  Future<void> _saveBook() async {
    await _firestore
        .collection(Values.PERSONAL_BOOKS)
        .document(userId)
        .collection(Values.BOOKS)
        .document(_selectedBookId)
        .setData(_books[_selectedBookId].toMap());
  }

  // Download selected book's PDF file from Firebase storage.
  Future<File> downloadPDF() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    // Create PDF file inside /directory/bookId.pdf.
    File file = new File('$dir/$selectedBookId.pdf');
    bool exists = await file.exists();
    // If PDF file already exists, return it.
    if (exists) return file;
    // PDF file not yet downloaded, download it first.
    String url = await _ref
        .child(Values.BOOKS)
        .child('$selectedBookId.pdf')
        .getDownloadURL();
    // Download the URL.
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    // Get the response's bytes from the request.
    var bytes = await consolidateHttpClientResponseBytes(response);

    /// Write [bytes] to the file.
    await file.writeAsBytes(bytes);
    return file;
  }
}
