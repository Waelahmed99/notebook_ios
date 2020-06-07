import '../constant_values.dart';

class Book {
  final String id;
  final String title;
  final String image;
  final String author;
  final String type;
  final int readCost;
  final int listenCost;
  final String description;
  final List<dynamic> selections;
  int nominations;
  bool isFavorite;
  bool isNominated;
  bool isReadBought;
  bool isListenBought;
  int sellCount;
  int viewCount;

  // Base constructor
  Book({
    this.id,
    this.author,
    this.title,
    this.image,
    this.sellCount,
    this.type,
    this.viewCount,
    this.readCost,
    this.listenCost,
    this.nominations,
    this.selections,
    this.description,
    this.isNominated = false,
    this.isFavorite = false,
    this.isReadBought = false,
    this.isListenBought = false,
  });

  // Helper constructor
  Book.create({
    this.id,
    this.author,
    this.title,
    this.image,
    this.sellCount,
    this.type,
    this.viewCount,
    this.readCost,
    this.listenCost,
    this.nominations,
    this.selections,
    this.description,
    this.isFavorite = false,
    this.isNominated = false,
    this.isReadBought = false,
    this.isListenBought = false,
  });

  Book.fromMap(
    String id,
    Map<String, dynamic> values, {
    String userId = '',
  }) : this.create(
          author: values[Values.BOOK_AUTHOR],
          id: id,
          image: values[Values.BOOK_IMAGE],
          isFavorite: (values[Values.BOOK_FAVORITE][userId] ?? false),
          title: values[Values.BOOK_TITLE],
          sellCount: values[Values.BOOK_SELL_COUNT],
          type: values[Values.BOOK_TYPE],
          viewCount: values[Values.BOOK_VIEW_COUNT],
          readCost: values[Values.BOOK_READ_COST],
          listenCost: values[Values.BOOK_LISTEN_COST],
          description: values[Values.BOOK_DESCRIPTION],
          nominations: (values[Values.BOOK_NOMINATIONS] != null
              ? values[Values.BOOK_NOMINATIONS].length
              : 0),
          isNominated: (values[Values.BOOK_NOMINATIONS] != null
              ? (values[Values.BOOK_NOMINATIONS][userId] ?? false)
              : false),
          selections: values[Values.BOOK_SELECTIONS],
          isReadBought: values[Values.BOOK_READ_BOUGHT] != null
              ? (values[Values.BOOK_READ_BOUGHT][userId] ?? false)
              : false,
          isListenBought: values[Values.BOOK_LISTEN_BOUGHT] != null
              ? (values[Values.BOOK_LISTEN_BOUGHT][userId] ?? false)
              : false,
        );

  // To update the favorite state of a book
  // Book.changeState(Book book, {ChangeState state})
  //     : this.create(
  //         id: book.id,
  //         author: book.author,
  //         image: book.image,
  //         isFavorite: (state == ChangeState.FAVORITE)
  //             ? !book.isFavorite
  //             : book.isFavorite,
  //         isNominated: (state == ChangeState.NOMINATION)
  //             ? !book.isNominated
  //             : book.isNominated,
  //         title: book.title,
  //         sellCount: book.sellCount,
  //         type: book.type,
  //         viewCount: book.viewCount,
  //         readCost: book.readCost,
  //         listenCost: book.listenCost,
  //         description: book.description,
  //         nominations: book.nominations,
  //         selections: book.selections,
  //         isReadBought: book.isReadBought,
  //         isListenBought: book.isListenBought,
  //       );

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      Values.BOOK_ID: this.id,
      Values.BOOK_AUTHOR: this.author,
      Values.BOOK_IMAGE: this.image,
      Values.BOOK_IS_FAVORITE: this.isFavorite,
      Values.BOOK_TITLE: this.title,
      Values.BOOK_SELL_COUNT: this.sellCount,
      Values.BOOK_TYPE: this.type,
      Values.BOOK_VIEW_COUNT: this.viewCount,
      Values.BOOK_READ_COST: this.readCost,
      Values.BOOK_LISTEN_COST: this.listenCost,
      Values.BOOK_DESCRIPTION: this.description,
      Values.BOOK_NOMINATIONS: this.nominations,
      Values.BOOK_SELECTIONS: this.selections,
      Values.BOOK_IS_READ_BOUGHT: this.isReadBought,
      Values.BOOK_IS_LISTEN_BOUGHT: this.isListenBought,
    };
    return result;
  }
}
