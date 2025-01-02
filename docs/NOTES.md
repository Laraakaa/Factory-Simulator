# Notes

## Factory Idea

- **Precursor 1 (Metal Alloy Plate)**: Created from Precursor 2 (Metal Ingot).
- **Precursor 2 (Metal Ingot)**: Shared between Precursor 1 and Precursor 3, acting as a core raw material.
- **Precursor 3 (Energy Crystal Housing)**: Made from Precursor 2 (Metal Ingot) and Precursor 4 (Insulation Polymer).
- **Precursor 4 (Insulation Polymer)**: Externally supplied and used only for Precursor 3.

## Floor Design

### Principles

- **Modularity**: Keep the factory modular so you can expand or tweak parts as needed.
- **Logical Workflow**: Materials should flow logically from inputs → processing → assembly → output.
- **Robot Pathing**: Leave enough room for robots to navigate between stations, minimizing collision and bottlenecks.
- **Zones**: Divide the factory into distinct zones for clarity and visual appeal (e.g., input area, processing area, assembly area, output area).

### Godot Implementation

- **Mesh Library**: Create the different meshes and add them all into a mesh library
- **Grid Map**: Design the factory layout using a grid map with the previously created mesh library