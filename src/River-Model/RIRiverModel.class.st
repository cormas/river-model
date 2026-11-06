"
I am a small river basin: a main river that splits around an island and joins again, and a creek that flows into it. A spill pollutes everything downstream of it, one segment per step. I am the example model of the reference page on networks on cormas.org.

## Responsibility:

- I build the basin: a grid of plots, the river segments between some of them, the main river and the creek as networks, and the basin as a network of both rivers.
- At each step, I let pollution move one segment downstream in the basin.
- I give access to the named plots, the rivers and the basin, so that the examples of the reference page can find them.

## Collaborators:

- `RIPlot`: the cells of my grid, some of them named, polluted or clean.
- `RISegment`: the directed links between plots, each with a depth.
- `RIRiver` and `RIBasin`: the networks.

## Public API and Key Messages

- `initBasin` and `initSpill`: the init methods. The second one also spills pollution at plot C.
- `step`: the control method.
- `plot:` and `river:` return a plot or a river by its name, and `basin` returns the basin.
- `exampleBasin` on my class side returns a basin ready to use, and the `script…` methods open it for the screenshots of the reference page.

The basin, as drawn on the reference page:

```
Main river:  A → B → D → E → F,  and around the island  B → G → D
Creek:       C → D
Basin:       the main river and the creek
```

```
RIRiverModel scriptOpenSimulation
```

### Implementation Points

- Pollution moves synchronously: the plots to pollute are chosen first, then polluted, so that it never moves more than one segment per step.
"
Class {
	#name : 'RIRiverModel',
	#superclass : 'CMModel',
	#instVars : [
		'basin'
	],
	#category : 'River-Model',
	#package : 'River-Model'
}

{ #category : 'accessing' }
RIRiverModel class >> aboutThisModel [

	^ 'A small river basin on a 30x30 grid. The main river splits around an island and joins again, and a creek flows into it. Each river is a network of segments, and the basin is a network of both rivers. A spill pollutes everything downstream of it, one segment per step. It is the example model of the reference page on networks on cormas.org.'
]

{ #category : 'examples' }
RIRiverModel class >> exampleBasin [

	<sampleInstance>
	^ self initializedWith: #initBasin afterSteps: 0
]

{ #category : 'examples' }
RIRiverModel class >> initializedWith: anInitSelector afterSteps: aNumber [
	"A basin initialized with anInitSelector, then run for aNumber steps."

	| model simulation |
	model := self new.
	simulation := CMSimulation for: model.
	simulation
		activeInitSelector: anInitSelector;
		activeControlSelector: #step;
		initializeSimulation.
	aNumber timesRepeat: [ simulation runStep ].
	^ model
]

{ #category : 'accessing' }
RIRiverModel class >> modelName [

	^ 'River'
]

{ #category : 'scripts' }
RIRiverModel class >> scriptBasinPointOfView [
	"Two steps after the spill at C, with the basin's point of view: every segment shows the same color, between blue and brown, because the basin decides."

	<script>
	| model |
	model := self initializedWith: #initSpill afterSteps: 2.
	self useDefaultPointsOfView.
	RIRiver activePovSelector: #povRiver.
	RIBasin activePovSelector: #povPollution.
	^ model openSpacePresenter
]

{ #category : 'scripts' }
RIRiverModel class >> scriptOpenSimulation [

	<script>
	^ CMSimulationApplication new
		  cormasModel: self new;
		  start
]

{ #category : 'scripts' }
RIRiverModel class >> scriptRivers [
	"The clean basin, with each river in a color of its own: the main river with its island, and the creek."

	<script>
	| model |
	model := self initializedWith: #initBasin afterSteps: 0.
	self useDefaultPointsOfView.
	RIRiver activePovSelector: #povRiver.
	^ model openSpacePresenter
]

{ #category : 'scripts' }
RIRiverModel class >> scriptSpill [
	"Two steps after the spill at C, with the segments' own point of view: C, D and E are polluted, and the segments leaving them are brown."

	<script>
	| model |
	model := self initializedWith: #initSpill afterSteps: 2.
	self useDefaultPointsOfView.
	^ model openSpacePresenter
]

{ #category : 'examples' }
RIRiverModel class >> useDefaultPointsOfView [
	"Points of view are chosen per class, so the scripts start from the same choice. Send me after creating the model."

	{
		RIPlot.
		RISegment.
		RIRiver.
		RIBasin } do: [ :class | class activePovSelector: #pov ]
]

{ #category : 'accessing' }
RIRiverModel >> basin [

	^ basin
]

{ #category : 'init' }
RIRiverModel >> createRiverFrom: aRow [

	| river |
	river := self newEntity: RIRiver.
	river name: aRow first.
	aRow allButFirst do: [ :chain |
			river
				addChainOf: RISegment
				through: (chain collect: [ :plotName | self plot: plotName ]) ].
	^ river
]

{ #category : 'init' }
RIRiverModel >> initBasin [

	<init>
	self
		createGridNumberOfRows: 30
		numberOfColumns: 30
		neighbourhood: 4
		closed: true.
	self namePlots.
	basin := self newEntity: RIBasin.
	self riverTable do: [ :row | basin add: (self createRiverFrom: row) ].
	self makeSegmentsShallow
]

{ #category : 'init' }
RIRiverModel >> initSpill [
	"The same basin, with a spill on the creek at C."

	<init>
	self initBasin.
	(self plot: 'C') pollute
]

{ #category : 'init' }
RIRiverModel >> makeSegmentsShallow [

	self shallowSegmentTable do: [ :pair |
			((self plot: pair first) outgoingLinksOfClass: RISegment) do: [
				:segment |
				segment to = (self plot: pair second) ifTrue: [
					segment depth: 0.5 ] ] ]
]

{ #category : 'init' }
RIRiverModel >> namePlots [

	self plotTable do: [ :row |
		(self cellAt: row second at: row third) name: row first ]
]

{ #category : 'accessing' }
RIRiverModel >> plot: aName [
	"Return the plot with this name. It is an error if there is none."

	^ self cells detect: [ :plot | plot name = aName ]
]

{ #category : 'map' }
RIRiverModel >> plotTable [
	"The named plots: a name, then the row and the column of the plot."

	^ #( #( 'A' 4 4 ) #( 'B' 10 12 ) #( 'C' 4 27 ) #( 'D' 19 20 )
	     #( 'E' 24 22 ) #( 'F' 27 29 ) #( 'G' 19 10 ) )
]

{ #category : 'accessing' }
RIRiverModel >> river: aName [
	"Return the river with this name. It is an error if there is none."

	^ self @@ RIRiver detect: [ :river | river name = aName ]
]

{ #category : 'map' }
RIRiverModel >> riverTable [
	"Each river: a name, then the chains of plots its water flows through, with a segment between each plot and the next."

	^ #( #( 'Main river' #( 'A' 'B' 'D' 'E' 'F' )
	        #( 'B' 'G' 'D' ) )
	     #( 'Creek' #( 'C' 'D' ) ) )
]

{ #category : 'map' }
RIRiverModel >> shallowSegmentTable [
	"The segments only 0.5 meters deep. All the others are 2 meters deep."

	^ #( #( 'B' 'D' ) )
]

{ #category : 'control' }
RIRiverModel >> step [
	"Pollution moves one segment downstream in the basin. All the plots are chosen first and polluted after, so pollution never moves more than one segment per step."

	<control>
	| plotsToPollute |
	plotsToPollute := Set new.
	(self cells select: [ :plot | plot isPolluted ]) do: [ :plot |
		plotsToPollute addAll: (plot nextEntitiesIn: basin) ].
	plotsToPollute do: [ :plot | plot pollute ]
]
