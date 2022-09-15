with Ada.Numerics.Discrete_Random;
with Common_Types; use Common_Types;

package Sequence_Generator is

   function Generate_Secret_Sequence return Guess_Int_Array;

private

   package Rand_Guess_Range is new Ada.Numerics.Discrete_Random
     (Single_Number_Guess_Range);
   Random_Generator : Rand_Guess_Range.Generator;
   --  Instantiation of the Discrete_Random generic used to generate a random
   --  sequence

end Sequence_Generator;
