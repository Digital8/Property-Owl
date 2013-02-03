ALTER TABLE  `owls` CHANGE  `aspect`  `aspect` ENUM(  'North',  'South',  'East',  'West',  'North-East',  'North-West',  'South-East',  'South-West',  ' ' )

ALTER TABLE  `owls` CHANGE  `indoor_features`  `indoor_features` TEXT, CHANGE  `outdoor_features`  `outdoor_features` TEXT, CHANGE  `other_features`  `other_features` TEXT;