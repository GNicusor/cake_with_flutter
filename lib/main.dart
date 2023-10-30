import 'package:cake_with_flutter/ShoppingCart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "dart:io";
import 'ShoppingCart.dart';
import "depozit.dart";
import "retete.dart";
import 'package:flutter/services.dart';
import 'information.dart';
import 'package:cake_with_flutter/ShoppingCart.dart';
import  'ShoppingCart.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ShoppingCart()),
      ],
      child: MaterialApp(
        home: CakeFactory(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class CakeFactory extends StatefulWidget {
  const CakeFactory({super.key});

  @override
  State<CakeFactory> createState() => _CakeFactoryState('');
}

class _CakeFactoryState extends State<CakeFactory> {

   List<Depozit> depozits = [];
   List<MySquare> squares = [];
   String _name = '';


   String ?idk;

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

    } catch (e) {
      print('Error loading Depozits from file: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => print('s-a apasat'),
        ),
        actions: <Widget> [
          FloatingActionButton(
              onPressed: () => Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) {
                    return CartPage();
                  },
                ),),
              child: Icon(Icons.shopping_basket),
          ),
        ],

        title:const Text("Welcome",
          style: TextStyle(
              fontSize: 30,
          )
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        double spacing = constraints.maxWidth / 18;
        return ListView(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: spacing,
              children:squares,
            ),
          ],
        );
      }),
    );
  }
   _CakeFactoryState(this.idk);
   void handleButtonPress(String name) {
     // Do something with the 'name' received from the MySquare widget
     print('Received name: $name');
   }

}

//Nota: de facut ca box-urile sa isi faca resize in functie de ecran
class MySquare extends StatelessWidget {
  List<ShoppingCart> chesti = [];
  String name;
  Image ?image;
  String ?detalii;
  int ?durata_pregatire;
  int ?nr_prajituri;
  String ?wtf;
  void Function()? onPressed;
  //MySquare(this.name) : image = Image.asset('assets/$name.png');
  MySquare(this.name, this.detalii, this.durata_pregatire, this.nr_prajituri) : image = Image.asset('assets/$name.png');


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Detalii:$detalii');
        showDialog(
            context: context,
            builder: (BuildContext context){
             return AlertDialog(
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(50),
               ),
               scrollable: true,
               content: ConstrainedBox(
                 constraints:const BoxConstraints(maxWidth: 700,minHeight: 800),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         ConstrainedBox(
                           constraints: BoxConstraints(
                               maxWidth: MediaQuery.of(context).size.width,
                               minHeight: 400),
                           child: Image.asset('assets/$name.png'),
                         )
                       ],
                     ),
                     Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Timp de pregatire:$durata_pregatire minute',
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
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         FloatingActionButton.extended(
                           onPressed: () {
                             Navigator.pop(context);
                             },
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                           label: Text("Cancel"),

                         ),
                         FloatingActionButton.extended(
                           onPressed: () {
                             Provider.of<ShoppingCart>(context,listen: false).addItemToCart(name, 10);
                             Navigator.pop(context);
                           },
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                           label: Text('BUY'),
                         )
                       ],
                     )
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

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('My Cart'),),
      body: Consumer<ShoppingCart>(builder: (context,value,child){
        return Column (
            children: [
              Expanded(
                  child: ListView.builder(
                    itemCount: value.cartItems.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context,index){
                        final cartItem = value.cartItems[index];
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(80),
                            ),
                            padding: EdgeInsets.all(25),
                            child: ListTile(
                              leading: Container(
                                  height: 500, // Adjust the height as needed
                                  width: 50, // Adjust the width as needed
                                  child: Image.asset('assets/${cartItem.name}.png',fit: BoxFit.fitWidth,),
                              ),
                              title: Text(cartItem.name),
                              subtitle: Text('Pret:20'),//lene pentru a modifica clasele sa includ un pret, modific later:D
                              trailing: IconButton(icon: Icon(Icons.cancel),
                                onPressed: (){
                                  Provider.of<ShoppingCart>(context, listen: false).removeItemFromCart(cartItem.name);
                                  print('${cartItem.name}');
                                },
                              ),
                              // You can also display the quantity if needed:
                              // subtitle: Text('Quantity: ${cartItem.quantity}'),
                            ),
                          ),
                        );
                      },
                  ))
            ],
        );
      })
    );
  }

}

