<p align="center">
  <img src="https://raw.githubusercontent.com/andromeda-oss/Nerve/main/.github/nerve.png" width="100%">
</p>

> 🤝 **Contributions Welcome**  
> I'm open to contributions and would be happy if you decided to help improve the project!

---

A lightweight and customizable Lua module bundler written in [Luvit](https://luvit.io/). Designed for projects that use `require()` to load Lua modules and want to compile everything into a single optimized `.lua` file with credits and minification.

---

## 📦 Features

- 📁 Bundles all required Lua files into a single output.
- 🧹 Minifies Lua code (excluding the credits).
- 🔖 Injects project metadata (name, version, author, etc.) from a `metadata.json`.
- 🧠 Automatically resolves nested `require("module.name")` calls.

---

## 🚀 Usage

### Structure

```bash
.\luvit.exe builder.lua <input> <output>
```

### Example

```bash
.\luvit.exe builder.lua test/core/init.lua output.lua
```
