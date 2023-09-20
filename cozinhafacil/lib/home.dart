import 'package:flutter/material.dart';

import 'receita.dart';

class CardGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: <Widget>[
        CardWidget(
          imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
          description: 'Descrição do Card 1',
          title: 'Card 1',
        ),
        CardWidget(
          imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
          description: 'Descrição do Card 2',
          title: 'Card 2',
        ),
        CardWidget(
          imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
          description: 'Descrição do Card 3',
           title: 'Card 3',
        ),
        CardWidget(
          imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
          description: 'Descrição do Card 4',
           title: 'Card 4',
        ),
        CardWidget(
          imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
          description: 'Descrição do Card 5',
           title: 'Card 5',
        ),
        CardWidget(
          imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
          description: 'Descrição do Card 6',
           title: 'Card 6',
        ),
        CardWidget(
          imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
          description: 'Descrição do Card 7',
           title: 'Card 7',
        ),
        CardWidget(
          imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
          description: 'Descrição do Card 8',
           title: 'Card 8',
        ),
      ],
    );
  }
}

class CardWidget extends StatelessWidget {
  final String imageUrl;
  final String description;
  final String title;

  CardWidget({required this.imageUrl, required this.description, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, 
          MaterialPageRoute(builder:(context) => DefaultCard(this.imageUrl,this.description,this.title)));
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => DefaultCard(this.imageUrl,this.description,this.title,'teste')),
        // );
      },
    child: Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 100.0,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              description, // Usamos a descrição passada como parâmetro
              style: TextStyle(fontSize: 14.0),
            ),
          ),
        ],
      ),
    )
    );
  }
}


