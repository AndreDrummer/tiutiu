import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:tiutiu/Custom/pet_detail_icons_icons.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/card_details.dart';
import 'package:tiutiu/Widgets/divider.dart';
import 'package:tiutiu/Widgets/dots_indicator.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/utils/constantes.dart';

class PetDetails extends StatefulWidget {
  @override
  _PetDetailsState createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  final PageController _pageController = PageController();
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
    Pet pet = arguments['petInfo'];
    String kind = arguments['kind'];

    void favoriteHandler() {
      setState(() {
        isFavorite = !isFavorite;
      });
    }    

    List details = [
      {'title': 'TIPO', 'text': pet.type, 'icon': PetDetailIcons.guidedog},
      {'title': 'RAÇA', 'text': pet.breed, 'icon': PetDetailIcons.dog},
      {
        'title': 'TAMANHO',
        'text': pet.size,
        'icon': PetDetailIcons.resize_small
      },
      {'title': 'SAÚDE', 'text': pet.health, 'icon': PetDetailIcons.healing},
      {
        'title': 'IDADE',
        'text': '${pet.ano}a ${pet.meses}m',
        'icon': PetDetailIcons.calendar
      },
    ];

    List userDetails = [
      {'text': pet.ownerName ?? '', 'imageN': pet.ownerPhotoURL ?? '', 'title': 'Clique p/ detalhar'},
      {
        'text': pet.ownerBetterContact == 0 ? pet.ownerPhoneNumber : pet.ownerLandline == 1  ? pet.ownerLandline : pet.ownerEmail,
        'icon': pet.ownerBetterContact == 0 ? PetDetailIcons.whatsapp : pet.ownerLandline == 1  ? Icons.phone : Icons.email,
        'title': 'Melhor contato',
        'color': pet.ownerBetterContact == 0 ? Colors.green : pet.ownerLandline == 1  ? Colors.orange : Colors.red,
      },
      {
        'title': 'Clique p/ navegar',
        'text': 'Localização',
        'imageN':
            'https://maps.googleapis.com/maps/api/staticmap?center=${pet.latitude}, ${pet.longitude}&zoom=14&markers=color&markers=color:red%7Clabel:%7c-16.7502014,%20-49.256370000000004&size=600x400&key=${Constantes.WEB_API_KEY}',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Detalhes de ${pet.name}'),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  'assets/cao e gato.png',
                ),
              )),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                showImages(pet.photos, pet.ownerName),
                Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: details.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CardDetails(
                          title: details[index]['title'],
                          icon: details[index]['icon'],
                          text: details[index]['text'],
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8.0,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: 0.0, maxHeight: 120),
                          child: Container(
                            width: double.infinity,
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          'Descrição',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .copyWith(color: Colors.black54),
                                        ),
                                      ),
                                      Divider(),
                                      Text(pet.details),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
                SizedBox(height: 5),
                CustomDivider(text: 'Informações do anunciante'),
                Container(
                  height: 170,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: userDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return UserCardInfo(
                          text: userDetails[index]['text'],
                          title: userDetails[index]['title'],
                          icon: userDetails[index]['icon'],
                          image: userDetails[index]['image'],
                          imageN: userDetails[index]['imageN'],
                          color: userDetails[index]['color'],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 140.0),
              ],
            ),
          ),
          Positioned(
            bottom: 18.0,
            left: kind == 'Donate' ? 20.0 : MediaQuery.of(context).size.width * 0.17,
            child: ButtonWide(
              text: kind == 'Donate' ? 'ADOTAR' : 'VI ELE AQUI PERTO',
              color: kind == 'Donate' ? Colors.red : Colors.green,
            ),
          )
        ],
      ),
      floatingActionButton: kind == 'Donate' ? FloatingActionButton(
        onPressed: () {
          print(isFavorite);
          favoriteHandler();
        },
        tooltip: isFavorite ? 'Favorito' : 'Favoritar',
        backgroundColor: isFavorite ? Colors.white : Colors.red,
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.white,
        ),
      ) : null,
    );
  }

  Widget showImages(Map photos, String announcerName) {
    return Stack(
      children: [
        Container(
          color: Colors.blueGrey[50],
          height: MediaQuery.of(context).size.height / 3,
          width: double.infinity,
          child: PageView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: photos.values.length,
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                photos.values.elementAt(index),
                fit: BoxFit.fill,
                loadingBuilder: loadingImage,
              );
            },
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: DotsIndicator(
              controller: _pageController,
              itemCount: photos.values.length,
              onPageSelected: (int page) {
                _pageController.animateToPage(
                  page,
                  duration: Duration(
                    milliseconds: 500,
                  ),
                  curve: Curves.ease,
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget loadingImage(
      BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Carregando imagem..'),
          LoadingJumpingLine.circle(),
        ],
      ),
    );
  }
}
