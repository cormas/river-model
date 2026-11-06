"
I am a plot of the river basin. I am clean or polluted, and a few of us have a name so that people can find us.

## Responsibility:

- I know whether I am polluted.
- I know my name, if I have one.
- I show pale sage when I am clean, and warm ochre when I am polluted.

## Collaborators:

- `RIRiverModel`: creates me, names me and pollutes me.
- `RISegment`: the river segments that join me to other plots.

## Public API and Key Messages

- `isPolluted`, `pollute`, `name`.

```
(RIRiverModel exampleBasin plot: 'D') isPolluted
```
"
Class {
	#name : 'RIPlot',
	#superclass : 'CMCell',
	#instVars : [
		'name',
		'isPolluted'
	],
	#category : 'River-Model',
	#package : 'River-Model'
}

{ #category : 'initialization' }
RIPlot >> initialize [

	super initialize.
	isPolluted := false
]

{ #category : 'accessing' }
RIPlot >> isPolluted [

	^ isPolluted
]

{ #category : 'accessing' }
RIPlot >> name [

	^ name
]

{ #category : 'accessing' }
RIPlot >> name: aString [

	name := aString
]

{ #category : 'actions' }
RIPlot >> pollute [
	"Pollution reaches me, and stays."

	isPolluted := true
]

{ #category : 'pov' }
RIPlot >> pov [
	"Pale sage land, and warm ochre where pollution has reached."

	<pov>
	^ (CMPointOfView color: (Color fromHexString: (isPolluted
						     ifTrue: [ 'D9A55B' ]
						     ifFalse: [ 'E9EFDC' ])))
		  borderWidth: 0;
		  yourself
]
