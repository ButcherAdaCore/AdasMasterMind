with Common_Types; use Common_Types;

package Sequence_Checker with SPARK_MODE => On is

   type Result_Literals_Type is
     (Number_Not_In_Sequence, Number_In_Sequence_In_Wrong_Place,
      Number_In_Sequence_In_Correct_Place);
   --  Describes the result of each individual guess

   type Results_Array_Type is
     array (Guess_Array_Type_Index_Range) of Result_Literals_Type;
   --  Groups the results of each individual guess into an array

   type Result_Code is
     (String_Is_Valid, String_Too_Long, String_Too_Short,
      String_Not_All_Integers);
   --  The various reasons why the inputted String sequence could fail

   function Sequence_Is_Valid (Sequence : in String) return Result_Code;
   --  Verify that the sequence is a valid String representation of an Integer
   --  or is equal to "exit"

   function String_Is_Int_Array (Guess_String : in String) return Boolean;
   --  Checks if the provided String is a sequence of Integers

   function Compare_Sequences
     (Guess_Sequence : String; Check_Sequence : Guess_Int_Array)
      return Results_Array_Type
     with Pre => String_Is_Int_Array (Guess_Sequence);

   --  Convert the String representation of the sequence in an Integer array
   --  compare the two sequences and return the result

   function Sequence_Found (Results : Results_Array_Type) return Boolean;
   --  Checks if the results of a sequence compare indicate that the sequence
   --  has been found

private

   function String_Guess_To_Int_Vector
     (Guess_String : in String) return Guess_Int_Array
     with Pre => String_Is_Int_Array (Guess_String);
   --  Converts String guesses into a 4 element array of
   --  Single_Number_Guess_Range

end Sequence_Checker;
