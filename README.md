# River model

A small river basin where a main river splits around an island and joins again, and a creek flows into it. Each river is a network of segments, and the basin is a network of both rivers. A spill pollutes everything downstream of it, one segment per step.

The model is the example of the [reference page on networks](https://cormas.org/docs/reference/networks) for [Cormas](https://github.com/cormas/cormas). Every snippet on that page runs on this model.

## Install

The model needs a version of Cormas with links and networks, which for now is the `dev` branch. In a Cormas image, execute:

```st
Metacello new
    repository: 'github://cormas/river-model:main/src';
    baseline: 'RiverModel';
    load.
```

Then open a simulation window, and choose `initBasin` or `initSpill`, and `step`
