# aegisub-macros
Aegisub automation macros

## Hyphen to dash
##### hyphen2dash.lua

  This automation replaces hyphens (-) with "en dashes" (–) in dialogues:

    l1: - Hello, my name is John.\N- Nice to meet you! I'm Frank.
    
    -> – Hello, my name is John.\N– Nice to meet you! I'm Frank.

  Hyphens used in words (e.g. "sugar-free") will not be replaced.

## Join-Dialogue
##### join-or-dialogue.lua
  
  This script includes two automation macros:
  
  1. Joins two lines with \\N (line break)
  
    l1: Hello, my name is John.

    l2: I think I've met you before.
    
    -> Hello, my name is John.\NI think I've met you before.
    
  2. Creates a dialogue from two lines with –
  
    l1: Hello, my name is John.

    l2: Nice to meet you! I'm Frank.
    
    -> – Hello, my name is John.\N– Nice to meet you! I'm Frank.
