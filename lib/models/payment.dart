import 'package:notebook_provider/models/enums.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class Payment {
  final BuyMode mode;
  final Function onSuccess;
  Payment({this.onSuccess, this.mode});

  Future<void> startPayment() async {
    _initSquarePayment();
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow,
        collectPostalCode: false);
  }

  // Card payment cancelled.
  void _onCancelCardEntryFlow() {
    // Handle the cancel callback
  }

/**
  * Callback when successfully get the card nonce details for processig
  * card entry is still open and waiting for processing card nonce details
  */
  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    try {
      // take payment with the card nonce details
      // you can take a charge
      // await chargeCard(result);

      // payment finished successfully
      // you must call this method to close card entry
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
      print(result);
    } on Exception catch (ex) {
      // payment failed to complete due to error
      // notify card entry to show processing errorQ
      InAppPayments.showCardNonceProcessingError(ex.toString());
    }
  }

/**
  * Callback when the card entry is closed after call 'completeCardEntry'
  */
  void _onCardEntryComplete() {
    onSuccess(mode);
    // Update UI to notify user that the payment flow is finished successfully
  }

  Future<void> _initSquarePayment() async {
    await InAppPayments.setSquareApplicationId(
        'sandbox-sq0idb-7GNU0nqZtIiQR15wJs-Sng');
  }
}
