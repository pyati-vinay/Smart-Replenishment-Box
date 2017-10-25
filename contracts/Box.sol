pragma solidity ^0.4.8;
//import "github.com/Arachnid/solidity-stringutils/strings.sol";



contract Box {
    
    
    address public owner ;


    struct clientandsupplier {
    string name;
    uint balance;
    }
    mapping(address=>clientandsupplier)  public suppliers;
    mapping(address=>clientandsupplier)  public clients;
    mapping(address=>product) public supplierstock ;
    mapping(address=>product) public clientstock;
    mapping(string=>address)  SupplierNameMapping;
    uint public suppliercount ;
    uint public clientcount;
    address[]  public supplierList;
    address[]  public clientList;

    string public productnames;
    
    struct product {
         string name ;
         uint quantity ;
         uint unitprice ;
        
    }
    function getSupplierCount() constant returns(uint count){

            count=suppliercount;
    }

    function getClientCount() constant returns(uint count){

            count=clientcount;
    }


    function getClientAddress(uint count) constant returns(address add){

           add=clientList[count-1];
    }

    function getSupplierAddress(uint count) constant returns(address add){

           add=supplierList[count-1];
    }

    function getSupplierAddressFromName(string name) constant returns(address add){

        add=SupplierNameMapping[name];
    }
    function addSupplier(address supplier_address,string supplier_name, uint bal)  {
        clientandsupplier   supp;
        supp.name=supplier_name;
        supp.balance=bal;
        suppliers[supplier_address]=supp;
        suppliercount= suppliercount+1;
        supplierList.push(supplier_address);
        SupplierNameMapping[supplier_name]=supplier_address;
        
    }
    
    
    
    function addClient(address client_address, string client_name, uint bal)   {
         clientandsupplier   client;
         client.name=client_name;
         client.balance=bal;
         clients[client_address]=client ;
         clientcount=clientcount+1;
         clientList.push(client_address);
        
    }
    
    
    function  check_Client(address cl_address) constant returns (bool Box_member){
        
        if (nullcheck(clients[cl_address].name))
            Box_member=false ;
        else  
            Box_member=true;
        
        
    
    }
    
    
    
    function  check_supplier(address  sr_address) constant  returns(bool Box1_member){
                
                if (nullcheck(suppliers[sr_address].name))
                    Box1_member=false ;
                else  
                    Box1_member=true;
                
                
            }
            
    function nullcheck(string message )  constant returns(bool isnull){
     
                bytes memory tempEmptyStringTest = bytes(message); // Uses memory
                            if (tempEmptyStringTest.length == 0) {
                                    isnull=true;
                            } else {
                                
                                    isnull=false;
                            
                            }
     
     }
   

    
    
    function pushProducttoBox(address to, string name, uint price, uint quantity) {
        product prod;
        prod.name=name;
        prod.unitprice=price;
        prod.quantity=quantity;
        supplierstock[to]=prod;
       
    }
    
    
    function getProductsSupplier(address ofsupplier) constant returns (string prod_name,uint prod_quant,uint unit_price,uint unit_bal,string supp_name) {

        product allProd= supplierstock[ofsupplier];
        prod_name=allProd.name;
        prod_quant=allProd.quantity;
        unit_price=allProd.unitprice;
        unit_bal=getBalanceSeller(ofsupplier);
        supp_name=suppliers[ofsupplier].name;

     }


      function getProductsBuyer(address ofbuyer) constant returns (string prod_name,uint prod_quant,uint unit_price,uint unit_bal,string client_name) {

        product allProd= clientstock[ofbuyer];
        prod_name=allProd.name;
        prod_quant=allProd.quantity;
        unit_price=allProd.unitprice;
        unit_bal=getBalanceBuyer(ofbuyer);
        client_name=clients[ofbuyer].name;

     }


     function buyProducts(address from,address to,uint quantity1){
        product sellerProducts = supplierstock[from] ;  
        product clientprod;
        clientprod.name=sellerProducts.name ;
        clientprod.quantity=quantity1;
        clientstock[to]=clientprod;
        supplierstock[from].quantity=supplierstock[from].quantity-quantity1;
        suppliers[from].balance= suppliers[from].balance + quantity1*supplierstock[from].unitprice ;
        clients[to].balance=clients[to].balance - quantity1*supplierstock[from].unitprice ;

     }



    function getBalanceSeller(address seller) constant returns(uint bal){

         bal=suppliers[seller].balance;
    }


     function getBalanceBuyer(address client) constant returns(uint bal){

         bal=clients[client].balance;
    }




    
}







