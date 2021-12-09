package Utils is
  type IntegerArray is Array (Integer range <>) of Integer;

  procedure Bubble_Sort (A : in out IntegerArray);

  function getBiggestNumberProduct (A : in IntegerArray;
                                    N : in Integer) return Integer;

  function GetLastSplitString(str : in String;
                              c   : in Character) return String; 

  function GetFirstSplitString(str : in String;
                               c   : in Character) return String; 


  function removeFirstSpace(str : in String) return String;
                                    
end Utils;