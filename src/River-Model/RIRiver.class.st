"
I am a river: a network of segments with a name. I can be the main river or a creek that flows into it.

## Responsibility:

- I hold the segments of one river.
- I know my name.
- My point of view `povRiver` shows all my segments in a color of my own.

## Collaborators:

- `RISegment`: my members.
- `RIBasin`: the network I belong to.

## Public API and Key Messages

- `name`, and the point of view `povRiver`.

```
(RIRiverModel exampleBasin river: 'Main river') sources
```
"
Class {
	#name : 'RIRiver',
	#superclass : 'CMNetwork',
	#instVars : [
		'name'
	],
	#category : 'River-Model',
	#package : 'River-Model'
}

{ #category : 'accessing' }
RIRiver >> name [

	^ name
]

{ #category : 'accessing' }
RIRiver >> name: aString [

	name := aString
]

{ #category : 'pov' }
RIRiver >> povRiver [
	"All my segments show a color of my own, taken in turn from a small palette."

	<pov>
	| palette |
	palette := #( '1F4E9C' '17A398' 'E07A5F' '6A4C93' ).
	^ CMPointOfView
		  color:
		  (Color fromHexString:
			   (palette at: self id - 1 \\ palette size + 1))
		  size: 0.35
]
