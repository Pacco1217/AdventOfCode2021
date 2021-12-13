package Utils is

  type unsigned_32 is mod 2**32;
  type unsigned_64 is mod 2**64;

  type IntegerArray is Array (Integer range <>) of Integer;
  type Unsigned_32_Array is array (Integer range <>) of unsigned_32;
  type Unsigned_64_Array is array (Integer range <>) of unsigned_64;

  procedure Bubble_Sort (A : in out IntegerArray);

  procedure Bubble_Sort (A : in out Unsigned_32_Array);

  procedure Bubble_Sort (A : in out Unsigned_64_Array);

  function getBiggestNumberProduct (A : in IntegerArray;
                                    N : in Integer) return Integer;

  function GetLastSplitString(str : in String;
                              c   : in Character) return String; 

  function GetFirstSplitString(str : in String;
                               c   : in Character) return String; 


  function removeFirstSpace(str : in String) return String;
                                    
end Utils;