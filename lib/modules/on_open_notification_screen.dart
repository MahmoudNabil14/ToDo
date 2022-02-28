import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnOpenNotificationScreen extends StatelessWidget {
  String title;
  String description;

  OnOpenNotificationScreen({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title!,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: description!.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: AppLocalizations.of(context)!
                            .taskDescriptionHintFallback1
                            .toUpperCase(),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 36.0,
                            color: Colors.red,
                            fontWeight: FontWeight.w900),
                      ),
                      TextSpan(
                          text: AppLocalizations.of(context)!
                              .taskDescriptionHintFallback2,
                          style: Theme.of(context).textTheme.labelMedium)
                    ]),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: InteractiveViewer(
                    child: SelectableText(
                      description!,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 22.0, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ));
  }
}
