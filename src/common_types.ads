package Common_Types is

   type Extended_Single_Number_Guess_Range is range -1 .. 9;
   --  The range of each number in the secret sequence plus an extension to
   --  indicate that a value has been found

   Found_Value : constant Extended_Single_Number_Guess_Range := -1;

   subtype Single_Number_Guess_Range is Extended_Single_Number_Guess_Range
   range 0 .. 9;
   --  The range of each number in the secret sequence

   subtype Guess_Array_Type_Index_Range is Integer range 1 .. 4;
   --  The range of numbers in the secret sequence

   type Guess_Int_Array is array (Guess_Array_Type_Index_Range) of
     Extended_Single_Number_Guess_Range;
   --  Type defining an integer vector representation of a sequence

   subtype Guess_String_Type is String (Guess_Array_Type_Index_Range);
   --  String type used to capture the User Input

end Common_Types;
