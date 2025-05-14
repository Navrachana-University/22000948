# 🇮🇳 GujaratiLang Compiler

A simple compiler frontend for a custom programming language written in Gujarati-style keywords. It uses Flex (Lex) and Bison (YACC) to convert code into Three-Address Code (TAC).

## 🧠 Language Features

This language supports:

| Feature               | Example                                  |
|-----------------------|------------------------------------------|
| Variable Declaration  | `banav x = 5;`                          |
| Assignment            | `x = x + y;`                            |
| If-Else Conditions    | `maate x > y { ... } nahito { ... }`    |
| While Loops           | `jyasudhi x < 10 { ... }`               |
| Return Statement      | `pheravo x;`                            |
| Break / Continue      | `chhodo;` / `chaluvado;`                |
| Print                 | `chhapo "Hello";`                       |

## 📁 File Structure

```
📦 GujaratiLang/
├── yacc.y           ← YACC file for parsing and TAC generation
├── lexer.l          ← LEX file for lexical analysis
├── input_code.txt   ← Sample program written in GujaratiLang
├── output.tac       ← Output file with generated TAC
├── README.md        ← This file
```

## 🚀 How to Compile and Run

### ✅ Requirements
- macOS/Linux system
- `flex` (for lexical analysis)
- `bison` (for parser generation)
- `gcc` (for compiling the C code)

Install via Homebrew if needed:
```bash
brew install flex bison gcc
```

### ✅ Steps to Build
1. Generate the parser:
   ```bash
   bison -d yacc.y
   ```

2. Generate the scanner:
   ```bash
   flex lexer.l
   ```

3. Compile everything:
   ```bash
   gcc -o compiler yacc.tab.c lex.yy.c -lfl
   ```

4. Run the compiler:
   ```bash
   ./compiler input_code.txt
   ```

5. View the TAC output:
   ```bash
   cat output.tac
   ```

## 📄 Example Input (input_code.txt)
```
banav x = 5;
banav y = 10;
x = x + y;

maate x > y {
    chhapo "x is greater!";
} nahito {
    chhapo "y is greater!";
}

jyasudhi x < 20 {
    x = x + 1;
    chhapo x;
}

pheravo x;
```

## 📦 Example TAC Output (output.tac)
```
x = 5
y = 10
t0 = x + y
x = t0
t1 = x > y
if t1 goto L1
goto L2
L1:
print "x is greater!"
goto L3
L2:
print "y is greater!"
L3:
L4:
t2 = x < 20
if t2 goto L5
goto L6
L5:
t3 = x + 1
x = t3
print x
goto L4
L6:
return x
```

## 🧠 Keywords Glossary

| Gujarati Keyword | English Equivalent |
|------------------|--------------------|
| `banav`          | declare variable   |
| `maate`          | if                 |
| `nahito`         | else               |
| `jyasudhi`       | while              |
| `pheravo`        | return             |
| `chhodo`         | break              |
| `chaluvado`      | continue           |
| `chhapo`         | print              |

## 🛠️ Contributors
- 👨‍💻 Developed by: Meet Vachhani
- 💡 Language inspiration: Gujarati-style keywords
