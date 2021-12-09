package body Utils is
  
  procedure Bubble_Sort (A : in out IntegerArray) is
    Temp : Integer;
  begin
     for I in reverse A'Range loop
        for J in A'First .. I loop
           if A(I) < A(J) then
              Temp := A(J);
              A(J) := A(I);
              A(I) := Temp;
           end if;
        end loop;
     end loop;
  end Bubble_Sort;
  
  function getBiggestNumberProduct (A : in IntegerArray;
                                    N : in Integer) return Integer is
    result : Integer := 1;
  begin
    for I in A'last-(N-1).. A'last loop 
      result := result * A(I);
    end loop;
    return result;
  end getBiggestNumberProduct;

  function GetLastSplitString(str : in String;
                              c   : in Character) return String is
  begin
    for I in str'Range loop
      if (str(I) = c) then
        return str(I+1 .. str'last);
      end if;
    end loop;
    return str;
  end GetLastSplitString;

  function GetFirstSplitString(str : in String;
                               c   : in Character) return String is
  begin
    for I in str'Range loop
      if (str(I) = c) then
        return str(str'First .. I-1);
      end if;
    end loop;
    return str;
  end GetFirstSplitString;

  function removeFirstSpace(str : in String) return String is
  begin
    if(str(str'First) = ' ') then
      return(str(str'First + 1 .. str'Last));
    else
      return str;
    end if;
  end removeFirstSpace;

end Utils;