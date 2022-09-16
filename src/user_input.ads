with Common_Types; use Common_Types;

package User_Input is

   function Get_User_Input return Guess_String_Type_Status;
   --  Capture, validate and return the input from the user

   function Get_Count_Tries return String;
   --  Return the number of times the user has entered a valid sequence

private

   Count_Tries : Positive := Positive'First;
   --  Keeps track of the number of attempts the user has made to guess the
   --  sequence

end User_Input;
