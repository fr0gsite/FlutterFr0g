class IPFSUploadNode {
  String name; //Name of the IPFS Node
  String url; //URL of the IPFS Node e.g ipfs.fr0g.site
  String protokoll; //Protokoll of the IPFS Node e.g https
  int port; //Port of the IPFS Node e.g 443
  String accountname; //Accountname / Contractname of the IPFS Provider

  String apirequest = "/api/request"; //API Request for the IPFS Node
  String apiupload = "/api/upload"; //API Upload for the IPFS Node

  IPFSUploadNode(
      this.name, this.url, this.protokoll, this.port, this.accountname);
}
