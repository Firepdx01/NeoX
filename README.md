# NeoX Language Prototype

Welcome to the **NeoX Language Prototype** repository! This project is an experimental design of a new programming language called **NeoX**. NeoX is envisioned as an intuitive, high-level language with built-in support for multimedia operations, window management, and cross-language integration (e.g. connecting to Python).

## Overview

**NeoX** features:
- **Modular Imports:** Import built-in modules using custom aliases (e.g. importing a module called `Class` as `A`).
- **Image Handling:** Load images from local file paths and bind functions to display them in windows.
- **Window Management:** Define window properties such as title and icon directly in code.
- **Extensible Classes:** Define and extend classes with user-defined functions. The prototype includes additional sample classes (e.g. `AClass`, `BClass`, `CClass`).
- **Python Integration:** Use a Python bridge module (`PyBridge`) to call Python functions directly from NeoX code.
- **Custom Syntax:** A unique syntax that allows chaining assignments and function bindings in a clear, expressive manner.

## Repository Structure

- **`main.nx`**  
  The main source file demonstrating:
  - Importing and aliasing built-in modules.
  - Loading an image and binding it to window display functions.
  - Setting window properties (title and icon).
  - Defining multiple classes and helper functions.
  - Connecting to Python via the bridge module.

- **`README.md`**  
  This file, which describes the project, its features, usage instructions, and contribution guidelines.

## How to Use

1. **Set Up Your Environment:**  
   - Install the NeoX interpreter (or use the provided runtime if available).
   - Ensure external resources (e.g., the image at `file://desktop/image.png` and a compatible Python installation for the Python bridge) are accessible.

2. **Run the NeoX Code:**  
   From your terminal, execute:
   ```bash
   neox main.nx
