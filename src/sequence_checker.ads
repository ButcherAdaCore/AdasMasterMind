with Common_Types; use Common_Types;

package Sequence_Checker with SPARK_MODE => On is

   type Result_Code is
     (String_Is_Valid, String_Too_Long, String_Too_Short,
      String_Not_All_Integers, String_Is_Exit_Code);
   --  The status of the inputted guess including the various reasons why the
   --  it could fail

   function Sequence_Is_Valid (Sequence : in String) return Result_Code;
   --  Verify that the sequence is a valid String representation of an Integer
   --  or is equal to "exit"

   function String_Is_Int_Array (Guess_String : in String) return Boolean;
   --  Checks if the provided String is a sequence of Integers

   function Character_Is_Figure
     (C : Character;
      X : Extended_Single_Number_Guess_Range)
      return Boolean
   is
      (Character'Pos (C) - Character'Pos ('0') = X)
   with
     Ghost,
     Pre => C in '0' .. '9';

   function Character_Misplaced_In_Sequence
     (P : Guess_Array_Type_Index_Range;
      C : Character;
      G : String;
      S : Guess_Int_Array)
      return Boolean
   is
      (for some Place in S'Range =>
         Place /= P
           and then Character_Is_Figure (C, S (Place))
           and then not Character_Is_Figure (G (Place), S (Place)))
   with
     Ghost,
     Pre => C in '0' .. '9'
       and then String_Is_Int_Array (G);

   function Compare_Sequences
     (Guess_Sequence : String; Check_Sequence : Guess_Int_Array)
      return UTF8_Results
     with
       Pre => String_Is_Int_Array (Guess_Sequence);

   type Result_Literals_Type is
     (Number_Not_In_Sequence, Number_In_Sequence_In_Wrong_Place,
      Number_In_Sequence_In_Correct_Place);
   --  Describes the result of each individual guess

   type Results_Array_Type is
     array (Guess_Array_Type_Index_Range) of Result_Literals_Type;
   --  Groups the results of each individual guess into an array

   function Compare_Sequences
     (Guess_Sequence : String; Check_Sequence : Guess_Int_Array)
      return Results_Array_Type
     with
       Pre => String_Is_Int_Array (Guess_Sequence),
       Post =>
         (for all Place in Guess_Array_Type_Index_Range =>
            (if Character_Is_Figure (Guess_Sequence (Place),
                                     Check_Sequence (Place))
             then Compare_Sequences'Result (Place) =
                    Number_In_Sequence_In_Correct_Place
             elsif Character_Misplaced_In_Sequence (Place,
                                                    Guess_Sequence (Place),
                                                    Guess_Sequence,
                                                    Check_Sequence)
             then Compare_Sequences'Result (Place) =
                    Number_In_Sequence_In_Wrong_Place
             else Compare_Sequences'Result (Place) =
                    Number_Not_In_Sequence));
   --  Convert the String representation of the sequence in an Integer array
   --  compare the two sequences and return the result

   function Sequence_Found (Results : UTF8_Results) return Boolean;
   --  Checks if the results of a sequence compare indicate that the sequence
   --  has been found

private

   function String_Guess_To_Int_Vector
     (Guess_String : in String) return Guess_Int_Array
     with
       Pre => String_Is_Int_Array (Guess_String),
       Post =>
          (for all Place in Guess_Array_Type_Index_Range =>
             Character_Is_Figure (Guess_String (Place),
                                  String_Guess_To_Int_Vector'Result (Place)));
   --  Converts String guesses into a 4 element array of
   --  Single_Number_Guess_Range

   function Convert_Results_To_UTF8_Results (Results : Results_Array_Type)
                                             return UTF8_Results;
   --  Convert the array of literal results to a UTF8 visualisation

end Sequence_Checker;
