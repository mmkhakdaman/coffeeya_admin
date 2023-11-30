import 'package:coffeeya/auth/repositories/auth_repository.dart';
import 'package:coffeeya/core/config/constant.dart';
import 'package:coffeeya/core/config/token.dart';
import 'package:coffeeya/core/models/error.dart';
import 'package:coffeeya/core/models/response_model.dart';
import 'package:coffeeya/core/models/tenant_model.dart';
import 'package:coffeeya/core/widgets/buttons/primary_button.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;

  Future<void> login() async {
    isLoading = true;
    setState(() {});

    if (formKey.currentState!.saveAndValidate()) {
      await AuthRepository.login(phone: formKey.currentState!.fields['phone']!.value, password: formKey.currentState!.fields['password']!.value).then((value) {
        Token.setAccessToken(value.data!.accessToken);
        context.goNamed('home');
      }).catchError((error) {
        if (error is ResponseModel) {
          if (error.error?.errors != null) {
            setFormError(error: error.error!, formKey: formKey);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.json['message'].toString()),
              ),
            );
          }
        }
      }).whenComplete(() {
        isLoading = false;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('کافیا'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: FormBuilder(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'ورود',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),
                    DropdownSearch<TenantModel>(
                      asyncItems: (String filter) async {
                        List<TenantModel> teants = [];
                        Dio().close();
                        final response = await Dio().get(
                          "https://api.coffeeya.ir/api/tenant/search",
                          queryParameters: {"name": filter},
                        );
                        if (response.statusCode == 200) {
                          for (var item in response.data['data']) {
                            teants.add(TenantModel.fromJson(item));
                          }
                        }
                        return teants;
                      },
                      itemAsString: (item) {
                        return item.name;
                      },
                      popupProps: const PopupProps.menu(
                        fit: FlexFit.loose,
                      ),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "کافه",
                          hintText: "نام کافه را وارد کنید",
                        ),
                      ),
                      onChanged: (TenantModel? data) {
                        Constants.setBaseUrl("https://${data!.domain!.domain!}/");
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'phone',
                      decoration: const InputDecoration(
                        labelText: 'موبایل',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'password',
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'رمز عبور',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      onPressed: () {
                        login();
                      },
                      isLoading: isLoading,
                      child: const Text('ورود'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
