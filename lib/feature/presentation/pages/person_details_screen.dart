import 'package:flutter/material.dart';
import 'package:Rick_and_Morty_wiki/common/app_colors.dart';
import 'package:Rick_and_Morty_wiki/feature/domain/entities/person_entity.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/widgets/person_cache_image_widget.dart';

class PersonDetailsPage extends StatelessWidget {
  final PersonEntity person;

  const PersonDetailsPage({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Text(
              '${person.name}',
              style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w700,),
                textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              child: PersonCacheImage(
                imageUrl: person.image,
                width: 300,
                height: 300,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                      color: person.status == 'Alive'
                          ? Colors.green
                          : person.status == 'Dead'
                              ? Colors.red
                              : Colors.white70,
                      borderRadius: BorderRadius.circular(50)),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  '${person.status}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                )
              ],
            ),
            if (person.type.isNotEmpty) ..._buildTextInfo(title: 'Type', info: person.type),
            ..._buildTextInfo(
              title: 'Gender',
              info: person.gender,
            ),
            ..._buildTextInfo(
              title: 'Last number of episodes',
              info: person.episode.last.replaceAll(new RegExp(r'[^0-9]'), ''),
            ),
            ..._buildTextInfo(
              title: 'Species',
              info: person.species,
            ),
            ..._buildTextInfo(
              title: 'Last know location',
              info: person.location.name,
            ),
            ..._buildTextInfo(
              title: 'Origin',
              info: person.origin.name,
            ),
            ..._buildTextInfo(
              title: 'Was created',
              info: _getDateTimeFormat(person.created),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTextInfo({required String title, required String info}) {
    return [
      const SizedBox(
        height: 12,
      ),
      Text(
        '$title:',
        style: TextStyle(
          color: AppColors.greyColor,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 4,
      ),
      Text(
        '$info',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  String _getDateFormat(DateTime dateTime) {
    return '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  String _getTimeFormat(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  String _getDateTimeFormat(DateTime dateTime) {
    return '${_getDateFormat(dateTime)} ${_getTimeFormat(dateTime)}';
  }
}
