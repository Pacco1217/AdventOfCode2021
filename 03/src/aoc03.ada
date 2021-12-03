with text_io; use text_io;

procedure aoc03 is

  type IntegerArray is array (Integer range <>) of Integer;
  type StringValidity is
  record
    str         : String(1 .. 12);
    validOxygen : boolean := true;
    validCOtwo  : boolean := true;
  end record;
  type StringValidityArray is array (Integer range <>) of StringValidity;
  
  file : File_Type;
  fileName : constant string := "D:\Install\aoc\03\src\input.txt";
  gamma         : Integer := 0;
  epsilon       : Integer := 0;
  counter       : Integer := 0;
  nbCOvalid     : Integer := 0;
  nbOxygenValid : Integer := 0;
  
  procedure updateOxygenValidity (validityArr : in out StringValidityArray;
                                  pos         : in Integer) is
    oneCount    : Integer := 0;
    zeroCount   : Integer := 0;
    charToKeep  : Character := '0';
  begin
    -- counting occurence of bit
    for I in validityArr'range loop
      if (validityArr(I).validOxygen) then
        if (validityArr(I).str(pos) = '1') then
          oneCount := oneCount + 1;
        else
          zeroCount := zeroCount + 1;
        end if;
      end if;
    end loop;
    
    -- select char to keep
    if(oneCount >= zeroCount) then
      charToKeep := '1';
    end if;
    
    -- invalidate strings
    for I in validityArr'range loop
      if(validityArr(I).str(pos) /= charToKeep) then
        validityArr(I).validOxygen := false;
      end if;
    end loop;
  end updateOxygenValidity;
  
  procedure updateCOValidity (validityArr : in out StringValidityArray;
                              pos         : in Integer) is
    oneCount    : Integer := 0;
    zeroCount   : Integer := 0;
    charToCheck : Character := '1';
  begin
    -- counting occurence of bit
    for I in validityArr'range loop
      if (validityArr(I).validCOtwo) then
        if (validityArr(I).str(pos) = '1') then
          oneCount := oneCount + 1;
        else
          zeroCount := zeroCount + 1;
        end if;
      end if;
    end loop;
    
    -- select char to keep
    if(zeroCount <= oneCount) then
      charToCheck := '0';
    end if;
    
    -- invalidate strings
    for I in validityArr'range loop
      if(validityArr(I).str(pos) /= charToCheck) then
        validityArr(I).validCOtwo := false;
      end if;
    end loop;
  end updateCOValidity;
  
  function nbOfOxygenValid (validityArr : in StringValidityArray) return Integer is
    ret : Integer := 0;
  begin
    for I in validityArr'range loop
      if (validityArr(I).validOxygen) then
        ret := ret + 1;
      end if;
    end loop;
    return ret;
  end nbOfOxygenValid;
  
  function nbOfCOValid (validityArr : in StringValidityArray) return Integer is
    ret : Integer := 0;
  begin
    for I in validityArr'range loop
      if (validityArr(I).validCOtwo) then
        ret := ret + 1;
      end if;
    end loop;
    return ret;
  end nbOfCOValid;
  
  procedure print(validityArr : in StringValidityArray) is
  begin
    for I in validityArr'range loop
      if (validityArr(I).validCOtwo) then
        text_io.put_line(validityArr(I).str);
      end if;
      if (validityArr(I).validOxygen) then
        text_io.put_line(validityArr(I).str);
      end if;
    end loop;
  end print;
  
  function computeScrubber(validityArr : in StringValidityArray) return Integer is
    co     : Integer := 0;
    oxygen : Integer := 0;
    coPower : Integer := 0;
    o2Power : Integer := 0;
  begin
    for I in validityArr'range loop
      if (validityArr(I).validOxygen) then
        for J in reverse validityArr(I).str'range loop
          if (validityArr(I).str(J) = '1') then 
            oxygen := oxygen + 2**o2Power;
          end if;
          o2Power := o2Power + 1;
        end loop;
      end if;
      if (validityArr(I).validCOtwo) then
        for J in reverse validityArr(I).str'range loop
          if (validityArr(I).str(J) = '1') then 
            co := co + 2**coPower;
          end if;
          coPower := coPower + 1;
        end loop;
      end if;
    end loop;
    return oxygen * co;
  end computeScrubber;
  
begin
  -- Start main procedure
  text_io.put_line("aoc03 part1");
  open (file, In_File, fileName);
  declare
    firstLine    : String := Get_Line(file);
    countOneBit  : IntegerArray(firstLine'range) := (others => 0);
    countZeroBit : IntegerArray(firstLine'range) := (others => 0);
    power        : Integer := 0;
  begin
    close(file);
    open (file, In_File, fileName);
    
    while not End_Of_File(file) loop
      declare
        line : String := Get_Line(file);
      begin
        for I in line'range loop
          if (line(I) = '0') then
            countZeroBit(I) := countZeroBit(I) + 1;
          elsif (line(I) = '1' ) then
            countOneBit(I) := countOneBit(I) + 1;
          end if;
        end loop;
      end;
      counter := counter + 1;
    end loop;
    close(file);
    -- Création Gamma et Epsilon
    for I in reverse firstLine'range loop
      if (countOneBit(I) > countZeroBit(I)) then
        gamma := gamma + 2**power;
      end if;
      if(countOneBit(I) < countZeroBit(I)) then
        epsilon := epsilon + 2**power;
      end if;
      power := power + 1;
    end loop;
    
    text_io.put_line("result  " & Integer'Image(epsilon * gamma));
    text_io.put_line("aoc03 part2");
    
    declare
      SVAarray : StringValidityArray(1 .. counter);
      loopIndex : Integer := 1;
    begin
      open (file, In_File, fileName);
      while not End_Of_File(file) loop
        SVAarray(loopIndex).str := Get_Line(file);
        loopIndex := loopIndex + 1;
      end loop;
      close(file);
      for I in SVAarray(SVAarray'first).str'range loop
        nbCOvalid := nbOfCOValid(SVAarray);
        nbOxygenValid := nbOfOxygenValid(SVAarray);
        if (nbCOvalid > 1) then
          updateCOValidity(SVAarray, I);
        end if;
        if (nbOxygenValid > 1) then
          updateOxygenValidity(SVAarray, I);
        end if;
      end loop;
      text_io.put_line("Result : " & Integer'Image(computeScrubber(SVAarray)));
    end;
  end;
end aoc03;