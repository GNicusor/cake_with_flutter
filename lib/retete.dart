
class retete
{
  String reteta;
  int ?cantitate_zahar;
  int zahar; //il folosesc pentru a-mi da seama, daca prajitura este pentru diabetici
  int timePregatire;

  retete(this.reteta, this.zahar, this.timePregatire);

  retete.cuZahar(
      this.reteta, this.cantitate_zahar, this.zahar, this.timePregatire);
}