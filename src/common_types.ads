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

   subtype UTF8_Results is Wide_Wide_String (Guess_Array_Type_Index_Range);
   --  The results displayed as a sequence of UTF8 characters

   type Guess_String_Type_Status is record
      Guess_String : Guess_String_Type;
      Is_Exit_Code : Boolean;
   end record;
   --  Groups a guess String and an indication if the String is the exit
   --  request

   Exit_Request : constant String := "exit";
   --  Used to end the game

end Common_Types;
