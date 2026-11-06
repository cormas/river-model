"
I am a river basin: a network of rivers.

## Responsibility:

- I hold the rivers of the basin, and through them all their segments.
- I know how much of the basin is polluted.
- My point of view `povPollution` shows all my segments in one color, from blue when clean to brown when fully polluted.

## Collaborators:

- `RIRiver`: my members.

## Public API and Key Messages

- `pollutedFraction`, and the point of view `povPollution`.

```
RIRiverModel exampleBasin basin members
```
"
Class {
	#name : 'RIBasin',
	#superclass : 'CMNetwork',
	#category : 'River-Model',
	#package : 'River-Model'
}

{ #category : 'accessing' }
RIBasin >> pollutedFraction [
	"The share of my segments that carry pollution, from 0 to 1."

	^ (self links count: [ :segment | segment isPolluted ])
	  / self links size
]

{ #category : 'pov' }
RIBasin >> povPollution [
	"All my segments in one color, from clear water blue when the basin is clean to dark mud brown when all of it is polluted."

	<pov>
	^ CMPointOfView
		  color: ((Color fromHexString: '7A4E2D')
				   mixed: self pollutedFraction
				   with: (Color fromHexString: '3B8ED0'))
		  size: 0.35
]
