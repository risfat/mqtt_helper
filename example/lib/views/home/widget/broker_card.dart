import 'package:example/main.dart';
import 'package:flutter/material.dart';

class BrokerCard extends StatelessWidget {
  const BrokerCard({super.key, required this.broker});

  final BrokerModel broker;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimens.percentWidth(1),
      child: Card(
        color: ColorsValue.primaryColorDark.withOpacity(.5),
        child: Padding(
          padding: Dimens.edgeInsets10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Broker Name : ${broker.brokerName}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Styles.black16,
              ),
              Dimens.boxWidth4,
              Text(
                'Port Number : ${broker.portNumber}',
                style: Styles.black16,
              ),
              Text(
                'Topics : ',
                style: Styles.black16,
              ),
              ...List.generate(
                broker.topics.length,
                (index) => Text(
                  '${index + 1} : ${broker.topics[index].topic}',
                  style: Styles.black16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
