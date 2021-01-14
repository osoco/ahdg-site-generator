Class {
	#name : #BaselineOfAHDGGenerator,
	#superclass : #BaselineOf,
	#category : #BaselineOfAHDGGenerator
}

{ #category : #baselines }
BaselineOfAHDGGenerator >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ self configureChrysalOn: spec.
			self configurePillarOn: spec.
			self configureMustacheOn: spec.
			self configureNeoJSONOn: spec.
			spec
				package: #'AHDG-Generator-Core'
				with: [ spec requires: #('Chrysal' 'Pillar' 'Mustache' 'NeoJSON') ].
			spec
				group: 'Core' with: #('AHDG-Generator-Core');
				group: 'default' with: #('Core') ]
]

{ #category : #baselines }
BaselineOfAHDGGenerator >> configureChrysalOn: spec [
		spec
			baseline: #Chrysal with: [ 
				spec 
					repository: 'github://Ducasse/Chrysal:v1.0.0/src'].
]

{ #category : #baselines }
BaselineOfAHDGGenerator >> configureMustacheOn: spec [
	spec
		baseline: #Mustache
		with: [ spec
				repository: 'github://noha/mustache/repository']
]

{ #category : #baselines }
BaselineOfAHDGGenerator >> configureNeoJSONOn: spec [
	spec
		baseline: #NeoJSON
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ]
]

{ #category : #baselines }
BaselineOfAHDGGenerator >> configurePillarOn: spec [
	spec
		baseline: #Pillar
		with: [ spec
				repository: 'github://pillar-markup/pillar:dev-8/src';
				loads: 'ALL' ]
]
