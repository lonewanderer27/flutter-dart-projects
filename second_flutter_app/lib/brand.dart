import 'package:flutter/material.dart';
import 'package:second_flutter_app/constants/app_gradients.dart';
import 'package:second_flutter_app/gradient_text.dart';
import 'package:second_flutter_app/models/company.dart';

class Brand extends StatelessWidget {
  const Brand({super.key, required this.company});

  final Company company;
  String leftNamePart() =>
      company.name.substring(0, (company.name.length / 2).round());
  String rightNamePart() => company.name
      .substring((company.name.length / 2).round(), company.name.length);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Split text of the brand
        company.splitNameGradient == true
            ? Wrap(
                children: <Widget>[
                  GradientText(leftNamePart(),
                      gradient: AppGradients.stratpointGradient,
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                  Text(
                    rightNamePart(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            : GradientText(
                company.name,
                gradient: company.nameGradient,
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),

        // Description of the brand
        GradientText(
          company.description,
          gradient: company.descriptionGradient,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
