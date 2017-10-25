 pragma solidity ^0.4.8;

 library StringParser {
     
    
 
 function strConcat(string _a, string _b, string _c, string _d, string _e) constant returns (bytes){
    bytes memory _ba = bytes(_a);
    bytes memory _bb = bytes(_b);
    bytes memory _bc = bytes(_c);
    bytes memory _bd = bytes(_d);
    bytes memory _be = bytes(_e);
    string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
    bytes memory babcde = bytes(abcde);
    uint k = 0;
    for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
    for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
    for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
    for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
    for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
    return babcde;
}

/*function strConcat(string _a, string _b, string _c, string _d) constant returns (string) {
    return strConcat(_a, _b, _c, _d, "");
}

function strConcat(string _a, string _b, string _c) constant returns (string) {
    return strConcat(_a, _b, _c, "", "");
}

function strConcat(string _a, string _b) constant returns (string) {
    return strConcat(_a, _b, "", "", "");
}*/
    
    


 

function bytes32ToString (bytes32 data) constant returns (string) {
    bytes memory bytesString = new bytes(32);
    for (uint j=0; j<32; j++) {
      byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
      if (char != 0) {
        bytesString[j] = char;
      }
    }

    return string(bytesString);
  }

 
function uintToBytes(uint v) constant returns (bytes32 ret) {
    if (v == 0) {
        ret = '0';
    }
    else {
        while (v > 0) {
            ret = bytes32(uint(ret) / (2 ** 8));
            ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
            v /= 10;
        }
    }
    return ret;
}
    
    
}
