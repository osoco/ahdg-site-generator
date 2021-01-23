Class {
	#name : #AHDGPillarHTMLWriter,
	#superclass : #PRHTMLWriter,
	#category : #'AHDG-Generator-Core'
}

{ #category : #'visiting-document' }
AHDGPillarHTMLWriter >> visitExternalLink: anExternalLink [
	| linkTag |
	linkTag := canvas tag
		name: 'a';
		parameterAt: 'href'
			put: anExternalLink localFileOrExternalReference;
		yourself.
	anExternalLink parameters
		at: 'target'
		ifPresent: [ :target | linkTag parameterAt: 'target' put: target asString ].
	linkTag with: anExternalLink alias
]
