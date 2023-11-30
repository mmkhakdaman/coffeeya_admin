import 'package:coffeeya/core/helpers/notification.dart';
import 'package:coffeeya/core/models/response_model.dart';
import 'package:coffeeya/core/widgets/notification/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ErrorModel {
  String? message = "";
  Map<String, String>? errors;

  ErrorModel.fromJson(statusCode, json) {
    if (statusCode == 422 && json != null) {
      errors = {};
      message = json['message'].toString();
      if (json['errors'] != null) {
        json['errors'].forEach((key, value) {
          errors![key] = value.join('\n');
        });
      }
    }
  }
}

void setFormError({required ErrorModel error, required GlobalKey<FormBuilderState> formKey}) {
  error.errors?.forEach((key, value) {
    formKey.currentState?.fields[key]?.invalidate(value);
  });
}

Future<void> handelErrorAction({required ResponseModel response, Function? finalAction}) async {
  final statusCode = response.statusCode;
  switch (statusCode) {
    case 402:
      toast(
        message: "حساب کاربری شما غیر فعال شده است",
        status: ToastStatus.danger,
      );
      break;
    case 403:
      toast(
        message: response.json['detail'],
        status: ToastStatus.danger,
      );
      break;
    case 422:
      toast(
        message: "خطا در اعتبار سنجی",
        status: ToastStatus.danger,
      );
      break;
    case 500:
      toast(
        message: "خطای سرور",
        status: ToastStatus.danger,
      );
      break;
    default:
  }
}
