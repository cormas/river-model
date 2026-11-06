"
I am a segment of a river between two plots. Water flows through me in one direction, from my `from` plot to my `to` plot.

## Responsibility:

- I carry water one way: I am a directed link.
- I know my depth, which a boat needs to pass, and whether I carry pollution.
- I show blue when clean and brown when polluted, wider when deeper.

## Collaborators:

- `RIPlot`: my two ends.
- `RIRiver`: the river I belong to.

## Public API and Key Messages

- `depth`, `isPolluted`.

```
(RIRiverModel exampleBasin river: 'Creek') links
```
"
Class {
	#name : 'RISegment',
	#superclass : 'CMLink',
	#instVars : [
		'depth'
	],
	#category : 'River-Model',
	#package : 'River-Model'
}

{ #category : 'accessing' }
RISegment >> depth [
	"In meters."

	^ depth
]

{ #category : 'accessing' }
RISegment >> depth: aNumber [

	depth := aNumber
]

{ #category : 'initialization' }
RISegment >> initialize [

	super initialize.
	depth := 2
]

{ #category : 'testing' }
RISegment >> isPolluted [
	"Pollution flows through me when the plot I leave is polluted."

	^ self from isPolluted
]

{ #category : 'pov' }
RISegment >> pov [
	"Clear water blue when clean and dark mud brown when polluted. Deeper segments look wider."

	<pov>
	^ CMPointOfView
		  color: (Color fromHexString: (self isPolluted
					    ifTrue: [ '7A4E2D' ]
					    ifFalse: [ '3B8ED0' ]))
		  size: 0.15 + (depth * 0.1)
]
