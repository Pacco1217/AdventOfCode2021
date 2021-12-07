with text_io; use text_io;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure aoc04 is

  type MarkedInteger is
  record
    int    : Integer := 0;
    marked : boolean := false;
  end record;
  
  
  type Matrix is array(1..5,1..5) of MarkedInteger;
  type MatrxArray is array (Integer range<>) of Matrix;
  type IntegerArray is array (Integer range <>) of Integer;
  type MatrixIndex is mod 5;
  type WinningBoardArray is array(Integer range <>) of boolean;
  
  file     : File_Type;
  fileName : constant string := "D:\Install\aoc\04\src\input.txt";
  
  inputArray : IntegerArray(1 .. 100);
  matrixArr  : MatrxArray(1..100);
  
  firstLine : boolean := true;
  lineCount : Integer := 1;
  
  lastLineBlank : boolean := false;
  
  indexMat : MatrixIndex := 0;
  matrixCount : Integer := 1;
  
  winner : boolean := false;
  winningBoard : Matrix;
  winningNumber : Integer := 0;
  
  lastWinningBoard : Matrix;
  lastWinningNumber : Integer := 0;
  winningBoardArr   : WinningBoardArray(1..100) := (others => false);
  
  procedure getInputInteger (str : in String) is
    count : Integer := 0;
    lastComma : Integer := 0;
    index      : Integer := 1;
  begin
    for I in str'range loop
      if(str(I) = ',') then
        inputArray(index) := Integer'Value(Str(lastComma+1 .. I-1));
        lastComma := I;
        index := index + 1;
        count := count + 1;
        if (count = 99) then
          inputArray(index) := Integer'Value(Str(I+1 .. str'last));
        end if;
      end if;
    end loop;
  end getInputInteger;
  
  procedure fillMatrixRow(str : in String;
                          m   : in out Matrix;
                          row : in Integer) is
    count : Integer := 0;
    lastSpace : Integer := 0;
    index      : Integer := 1;
  begin
    for I in str'range loop
      if (str(I) = ' ') then
        if (I-1 > 1 ) then
          if(str(I-1) /= ' ') then
            m(row, index).int := Integer'Value(str(lastSpace+1 .. I-1));
            index := index + 1;
            count := count + 1;
            if(count = 4) then
              m(row, index).int := Integer'Value(Str(I+1 .. str'last));
            end if;
          end if;
        end if;
        lastSpace := I;
      end if;
    end loop;
  end fillMatrixRow;
  
  procedure printMatrix(m : in Matrix) is
  begin
    for I in m'range loop
      for J in m'range loop
        text_io.put(Integer'Image(m(I,J).int) & " ");
      end loop;
      text_io.put_line("");
    end loop;
    text_io.put_line("");
  end printMatrix;
  
  procedure printMatrixMarked(m : in Matrix) is
  begin
    for I in m'range loop
      for J in m'range loop
        text_io.put(Boolean'Image(m(I,J).marked) & " ");
      end loop;
      text_io.put_line("");
    end loop;
    text_io.put_line("");
  end printMatrixMarked;
  
  procedure markBoard(m   : in out Matrix;
                      num : in Integer) is
  begin
    for I in m'range loop
      for J in m'range loop
        if (m(i,j).int = num) then
          m(i,j).marked := true;
        end if;
      end loop;
    end loop;
  end markBoard;
  
  procedure checkWinningBoard(m         : in Matrix;
                              isWinning : out boolean) is
  begin
    isWinning := false;
    --check row
    for I in m'range loop
      isWinning := m(I,1).marked and m(I,2).marked and m(I,3).marked and m(I,4).marked and m(I,5).marked;
      if (isWinning) then
        return;
      end if;
    end loop;
    
    for I in m'range loop
      isWinning := m(1,I).marked and m(2,I).marked and m(3,I).marked and m(4,I).marked and m(5,I).marked;
      if (isWinning) then
        return;
      end if;
    end loop;
    
  end checkWinningBoard;
  
  function computeScore(m   : in Matrix;
                        num : in Integer) return Integer is
    result : Integer := 0;
  begin
    for I in m'range loop
      for J in m'range loop
        if (m(i,j).marked = false) then
          result := result + m(i,j).int;
        end if;
      end loop;
    end loop;
    return result * num;
  end computeScore;
begin
  text_io.put_line("aoc04 part1");
  open (file, In_File, fileName);
  while not End_Of_File(file) loop
    declare
      line : String := Get_Line(file);
    begin
      if (firstLine) then
        getInputInteger(line);
        firstLine := false;
      else
        if (Index_Non_Blank(line) = 0) then
          lastLineBlank := true;
        else
          fillMatrixRow(line, matrixArr(matrixCount), Integer(indexMat)+1);
          indexMat := indexMat + 1;
          if (indexMat = 0) then
            matrixCount := matrixCount + 1;
          end if;
        end if;
      end if;
      lineCount := lineCount + 1;
    end;
  end loop;
  close(file);
  
  for I in inputArray'range loop
    for J in matrixArr'range loop
      markBoard(matrixArr(J), inputArray(I));
      checkWinningBoard(matrixArr(J), winner);
      if (winner) then
        winningBoard := matrixArr(J);
        winningNumber := inputArray(I);
        printMatrixMarked(winningBoard);
      end if;
      exit when winner;
    end loop;
      exit when winner;
  end loop;
  text_io.put_line(Integer'Image(computeScore(winningBoard, winningNumber)));
  
  --RESET DATA
  firstLine   := true;
  indexMat    := 0;
  matrixCount := 1;
  open (file, In_File, fileName);
  while not End_Of_File(file) loop
    declare
      line : String := Get_Line(file);
    begin
      --text_io.put_line(line);
      if (firstLine) then
        getInputInteger(line);
        firstLine := false;
      else
        if (Index_Non_Blank(line) = 0) then
          lastLineBlank := true;
        else
          fillMatrixRow(line, matrixArr(matrixCount), Integer(indexMat)+1);
          indexMat := indexMat + 1;
          if (indexMat = 0) then
            matrixCount := matrixCount + 1;
          end if;
        end if;
      end if;
      lineCount := lineCount + 1;
    end;
  end loop;
  close(file);
  
  text_io.put_line("aoc04 part2");
  
  for I in inputArray'range loop
    for J in matrixArr'range loop
      if(winningBoardArr(J) = false) then
        markBoard(matrixArr(J), inputArray(I));
        checkWinningBoard(matrixArr(J), winner);
        if (winner) then
          lastWinningBoard := matrixArr(J);
          lastWinningNumber := inputArray(I);
          winningBoardArr(J) := true;
        end if;
      end if;
    end loop;
  end loop;
  
  printMatrixMarked(lastWinningBoard);
  text_io.put_line(Integer'Image(computeScore(lastWinningBoard, lastWinningNumber)));
end aoc04;