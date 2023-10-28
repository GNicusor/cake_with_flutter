import 'package:flutter/material.dart';
import "dart:io";
import "depozit.dart";
import "retete.dart";
import 'package:flutter/services.dart';
import 'information.dart';

void main() => runApp(MaterialApp(home: CakeFactory(),debugShowCheckedModeBanner: false,));

class CakeFactory extends StatefulWidget {
  const CakeFactory({super.key});

  @override
  State<CakeFactory> createState() => _CakeFactoryState();
}

class _CakeFactoryState extends State<CakeFactory> {

   List<Depozit> depozits = [];
   List<MySquare> squares = [];

   @override
  void initState() {
    super.initState();
    loadDepozitsFromFile();
  }

  Future<void> loadDepozitsFromFile() async {
    //java stuff
    try {
      String fileContents = await rootBundle.loadString('values/depozit.txt');
      List<String> lines = fileContents.split('\n');

      for (String line in lines) {
        List<String> data = line.split('[');
        if (data.length == 6) {
          print('+1');
          String numePrajitura = data[0];
          int nr = int.parse(data[1]);
          int timePregatire = int.parse(data[2]);
          int cantitate_zahar = int.parse(data[4]);
          String detalii = data[5];
          print(detalii);
          Depozit depozit = Depozit.cuZahar(numePrajitura, nr, cantitate_zahar, timePregatire, true);
          MySquare square = MySquare(numePrajitura,detalii,timePregatire,nr);
          depozits.add(depozit);
          squares.add(square);
        }else if(data.length == 5)
        {
          String numePrajitura = data[0];
          int nr = int.parse(data[1]);
          int timePregatire = int.parse(data[2]);
          String detalii = data[4];
          Depozit depozit = Depozit(numePrajitura, nr, timePregatire, false);
          depozits.add(depozit);
          MySquare square = MySquare(numePrajitura,detalii,timePregatire,nr);
          squares.add(square);
        }
      }
      // Now, you have a list of Depozit objects loaded from the file
    } catch (e) {
      print('Error loading Depozits from file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome",
          style: TextStyle(
              fontSize: 30,
          )
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        double spacing = constraints.maxWidth / 18; // Adjust the divisor as needed
        return ListView(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: spacing,
              children: squares,
            ),
          ],
        );
      }),
    );
  }
}
//Nota: de facut ca box-urile sa isi faca resize in functie de ecran
class MySquare extends StatelessWidget {
  String name;
  Image ?image;
  String ?detalii;
  int ?durata_pregatire;
  int ?nr_prajituri;
  //MySquare(this.name) : image = Image.asset('assets/$name.png');
  MySquare(this.name, this.detalii, this.durata_pregatire, this.nr_prajituri) : image = Image.asset('assets/$name.png');
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Detalii:$detalii');
        showDialog(
            context: context,
            builder: (BuildContext){
             return Dialog(
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8.0),
               ),
               child: Align(
                 alignment: Alignment.center,
                 child: Column(

                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Container(
                           width: 150,
                           height: 150,
                           padding: EdgeInsets.only(top: 40),
                           child: Image.asset('assets/$name.png'),
                         )
                       ],
                     ),
                     Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Timp de pregatire:$durata_pregatire',
                            style: TextStyle(fontSize: 28),
                          )
                        ],
                      ),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              '      $detalii',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                   ],
                 ),
               ),
             );
            });
      },
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            margin: EdgeInsets.all(10),
            child: image,
          ),
          Text(
            "$name",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "16",
            style: TextStyle(fontSize : 16),
          )
        ],
      ),
    );
  }


}
