Class {
	#name : 'BaselineOfRiverModel',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRiverModel',
	#package : 'BaselineOfRiverModel'
}

{ #category : 'baselines' }
BaselineOfRiverModel >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				package: 'River-Model';
				package: 'River-Tests'
				with: [ spec requires: #( 'River-Model' ) ] ]
]
