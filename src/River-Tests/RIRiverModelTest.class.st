"
I check how pollution moves through the river basin: downstream only, one segment per step, through both channels around the island, and never up a creek.
"
Class {
	#name : 'RIRiverModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'basin',
		'simulation'
	],
	#category : 'River-Tests',
	#package : 'River-Tests'
}

{ #category : 'running' }
RIRiverModelTest >> pollutedPlotNames [

	^ (basin cells select: [ :plot |
		   plot isPolluted and: [ plot name isNotNil ] ])
		  collect: [ :plot | plot name ]
		  as: Set
]

{ #category : 'running' }
RIRiverModelTest >> runSteps: aNumber [

	aNumber timesRepeat: [ simulation runStep ]
]

{ #category : 'running' }
RIRiverModelTest >> setUp [

	super setUp.
	basin := RIRiverModel new.
	simulation := CMSimulation for: basin.
	simulation
		activeInitSelector: #initBasin;
		activeControlSelector: #step;
		initializeSimulation
]

{ #category : 'tests' }
RIRiverModelTest >> testACleanBasinStaysClean [

	self runSteps: 10.
	self assert: self pollutedPlotNames isEmpty
]

{ #category : 'tests' }
RIRiverModelTest >> testASpillMovesOneSegmentDownstreamPerStep [

	(basin plot: 'C') pollute.
	self runSteps: 1.
	self assert: self pollutedPlotNames equals: #( 'C' 'D' ) asSet.
	self runSteps: 1.
	self assert: self pollutedPlotNames equals: #( 'C' 'D' 'E' ) asSet
]

{ #category : 'tests' }
RIRiverModelTest >> testPollutionFollowsBothChannelsAroundTheIsland [

	(basin plot: 'B') pollute.
	self runSteps: 1.
	self assert: self pollutedPlotNames equals: #( 'B' 'D' 'G' ) asSet
]

{ #category : 'tests' }
RIRiverModelTest >> testPollutionNeverMovesUpstream [
	"A spill on the creek reaches the main river at D, and never goes up the main river to A, B or G."

	(basin plot: 'C') pollute.
	self runSteps: 10.
	self
		assert: self pollutedPlotNames
		equals: #( 'C' 'D' 'E' 'F' ) asSet
]

{ #category : 'tests' }
RIRiverModelTest >> testTheBasinPollutedFraction [
	"A segment carries pollution when the plot it leaves is polluted. After two steps of a spill at C, C, D and E are polluted, so the segments leaving them carry pollution: 3 of the 7 segments."

	(basin plot: 'C') pollute.
	self assert: basin basin pollutedFraction equals: 1 / 7.
	self runSteps: 2.
	self assert: basin basin pollutedFraction equals: 3 / 7
]

{ #category : 'tests' }
RIRiverModelTest >> testTheInitSpillPollutesTheCreek [

	| spilled |
	spilled := RIRiverModel new.
	(CMSimulation for: spilled)
		activeInitSelector: #initSpill;
		activeControlSelector: #step;
		initializeSimulation.
	self assert: (spilled plot: 'C') isPolluted.
	self deny: (spilled plot: 'A') isPolluted
]
