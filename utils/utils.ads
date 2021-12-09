package Utils is
  type IntegerArray is Array (Integer range <>) of Integer;

  procedure Bubble_Sort (A : in out IntegerArray);

  function getBiggestNumberProduct (A : in IntegerArray;
                                    N : in Integer) return Integer;
                                    
end Utils;