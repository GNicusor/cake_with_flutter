

class Depozit{

  String  numePrajitura ;
  int nrPrajitura ;
  int nrTotal = 30;
  int ?cantitate_zahar;
  int timePregatire;
  bool zahar;

  Depozit(this.numePrajitura, this.nrPrajitura, this.timePregatire, this.zahar);

  Depozit.cuZahar(this.numePrajitura, this.nrPrajitura, this.cantitate_zahar, this.timePregatire, this.zahar);

  void SetNrActual(int nr){
    this.nrPrajitura = nr;
  }
}