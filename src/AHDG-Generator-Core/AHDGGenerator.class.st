Class {
	#name : #AHDGGenerator,
	#superclass : #Object,
	#instVars : [
		'templatesDir',
		'contentsDir',
		'buildDir',
		'configFile',
		'config'
	],
	#category : #'AHDG-Generator-Core'
}

{ #category : #translating }
AHDGGenerator class >> generate [
	self new
		templatesDir: '../templates' asFileReference;
		contentsDir: '../contents' asFileReference;
		buildDir: '../web' asFileReference;
		configFile: '../config.json' asFileReference;
		generate
]

{ #category : #accessing }
AHDGGenerator >> buildDir [
	^ buildDir
]

{ #category : #accessing }
AHDGGenerator >> buildDir: anObject [
	buildDir := anObject
]

{ #category : #accessing }
AHDGGenerator >> config [
	^ config ifNil: [ 
		config := NeoJSONReader fromString: self configFile contents.
 ]
]

{ #category : #accessing }
AHDGGenerator >> configFile [
	^ configFile
]

{ #category : #accessing }
AHDGGenerator >> configFile: anObject [
	configFile := anObject
]

{ #category : #'as yet unclassified' }
AHDGGenerator >> configuredContentFile: aName [
	^ self contentFile: (self configuredProperty: aName)
]

{ #category : #accessing }
AHDGGenerator >> configuredProperty: aString [
^ self config at: aString
]

{ #category : #'as yet unclassified' }
AHDGGenerator >> configuredTemplate: aName [
	^ (self configuredTemplateFile: aName) asMustacheTemplate
]

{ #category : #'as yet unclassified' }
AHDGGenerator >> configuredTemplateFile: aName [
	^ self templatesDir / (self configuredProperty: aName)
]

{ #category : #'as yet unclassified' }
AHDGGenerator >> contentFile: aName [
^ self contentsDir / aName
]

{ #category : #accessing }
AHDGGenerator >> contentsDir [
	^ contentsDir
]

{ #category : #accessing }
AHDGGenerator >> contentsDir: anObject [
	contentsDir := anObject
]

{ #category : #'api - generation' }
AHDGGenerator >> copyAsset: aFileReference [
	aFileReference copyAllTo: self buildDir / aFileReference basename
]

{ #category : #'api - generation' }
AHDGGenerator >> copyAssets [

	(self configuredProperty: 'assets') do: [  :each | self copyAsset: each asFileReference ]
]

{ #category : #'private - exporting' }
AHDGGenerator >> exportFileContents: fileContents named: fileName [

	| outputDir outputFile |

	outputFile := self buildDir / fileName.
	outputFile ensureDelete.
	outputFile parent ensureCreateDirectory.
	outputFile
		writeStreamDo: [ :stream | stream nextPutAll: fileContents  ]
]

{ #category : #'api - generation' }
AHDGGenerator >> generate [
	self generateIndex.
	self generateCards.
	self copyAssets.
]

{ #category : #'private - generation' }
AHDGGenerator >> generateCards [
	| cardFile cardPillar cardContents cards previous next values cardHtmlContents |
	cards := self configuredProperty: 'cards'.
	cards
		doWithIndex: [ :each :index | 
			cardFile := self contentFile: (each at: 'alias') , '.pillar'.
			cardPillar := PRPillarParser parse: cardFile contents.
			cardContents := PRHTMLWriter write: cardPillar.
			previous := index > 1
				ifTrue: [ cards at: index - 1 ]
				ifFalse: [ cards atLast: 1 ].
			next := index < cards size
				ifTrue: [ cards at: index + 1 ]
				ifFalse: [ cards at: 1 ].
			values := Dictionary newFrom: each.
			values at: 'previousAlias' put: (previous at: 'alias').
			values at: 'previousName' put: (previous at: 'name').
			values at: 'nextAlias' put: (next at: 'alias').
			values at: 'nextName' put: (next at: 'name').
			values at: 'contents' put: cardContents.
			cardHtmlContents := self
				generateHtmlWith: (self configuredTemplate: 'cardTemplate')
				on: values.
			self
				exportFileContents: cardHtmlContents
				named: (each at: 'alias') , '.html' ]
]

{ #category : #'private - generation' }
AHDGGenerator >> generateHtmlWith: aMustacheTemplate on: aDictionary [
	| htmlContent |
	htmlContent := aMustacheTemplate
		value: aDictionary
		partials:
			{('footer'
				->
					(self configuredTemplate: 'footerTemplate')  )} asDictionary.
	^ htmlContent
]

{ #category : #'private - generation' }
AHDGGenerator >> generateIndex [
	| indexFile indexPillar indexContents indexTemplate values indexHtml |
	indexFile := self configuredContentFile: 'index'.
	indexPillar := PRPillarParser parse: indexFile contents.
	indexContents := PRHTMLWriter write: indexPillar.
	indexTemplate := self configuredTemplate: 'indexTemplate'.
	values := self config.
	values at: 'contents' put: indexContents.
	indexHtml := self generateHtmlWith: indexTemplate on: values.
	self exportFileContents: indexHtml named: 'index.html'
]

{ #category : #accessing }
AHDGGenerator >> templatesDir [
	^ templatesDir
]

{ #category : #accessing }
AHDGGenerator >> templatesDir: anObject [
	templatesDir := anObject
]
