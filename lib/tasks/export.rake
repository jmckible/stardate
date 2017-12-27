# Export to Health Kit XML
# rake export:weight[1]

namespace :export do

  preamble = <<~PREAMBLE
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE HealthData [
  <!-- HealthKit Export Version: 7 -->
  <!ELEMENT HealthData (ExportDate,Me,(Record|Correlation|Workout|ActivitySummary)*)>
  <!ATTLIST HealthData
    locale CDATA #REQUIRED
  >
  <!ELEMENT ExportDate EMPTY>
  <!ATTLIST ExportDate
    value CDATA #REQUIRED
  >
  <!ELEMENT Me EMPTY>
  <!ATTLIST Me
    HKCharacteristicTypeIdentifierDateOfBirth         CDATA #REQUIRED
    HKCharacteristicTypeIdentifierBiologicalSex       CDATA #REQUIRED
    HKCharacteristicTypeIdentifierBloodType           CDATA #REQUIRED
    HKCharacteristicTypeIdentifierFitzpatrickSkinType CDATA #REQUIRED
  >
  <!ELEMENT Record ((MetadataEntry|HeartRateVariabilityMetadataList)*)>
  <!ATTLIST Record
    type          CDATA #REQUIRED
    unit          CDATA #IMPLIED
    value         CDATA #IMPLIED
    sourceName    CDATA #REQUIRED
    sourceVersion CDATA #IMPLIED
    device        CDATA #IMPLIED
    creationDate  CDATA #IMPLIED
    startDate     CDATA #REQUIRED
    endDate       CDATA #REQUIRED
  >
  <!-- Note: Any Records that appear as children of a correlation also appear as top-level records in this document. -->
  <!ELEMENT Correlation ((MetadataEntry|Record)*)>
  <!ATTLIST Correlation
    type          CDATA #REQUIRED
    sourceName    CDATA #REQUIRED
    sourceVersion CDATA #IMPLIED
    device        CDATA #IMPLIED
    creationDate  CDATA #IMPLIED
    startDate     CDATA #REQUIRED
    endDate       CDATA #REQUIRED
  >
  <!ELEMENT Workout ((MetadataEntry|WorkoutEvent|WorkoutRoute)*)>
  <!ATTLIST Workout
    workoutActivityType   CDATA #REQUIRED
    duration              CDATA #IMPLIED
    durationUnit          CDATA #IMPLIED
    totalDistance         CDATA #IMPLIED
    totalDistanceUnit     CDATA #IMPLIED
    totalEnergyBurned     CDATA #IMPLIED
    totalEnergyBurnedUnit CDATA #IMPLIED
    sourceName            CDATA #REQUIRED
    sourceVersion         CDATA #IMPLIED
    device                CDATA #IMPLIED
    creationDate          CDATA #IMPLIED
    startDate             CDATA #REQUIRED
    endDate               CDATA #REQUIRED
  >
  <!ELEMENT WorkoutEvent EMPTY>
  <!ATTLIST WorkoutEvent
    type         CDATA #REQUIRED
    date         CDATA #REQUIRED
    duration     CDATA #IMPLIED
    durationUnit CDATA #IMPLIED
  >
  <!ELEMENT WorkoutRoute ((MetadataEntry|Location)*)>
  <!ATTLIST WorkoutRoute
    sourceName    CDATA #REQUIRED
    sourceVersion CDATA #IMPLIED
    device        CDATA #IMPLIED
    creationDate  CDATA #IMPLIED
    startDate     CDATA #REQUIRED
    endDate       CDATA #REQUIRED
  >
  <!ELEMENT Location EMPTY>
  <!ATTLIST Location
    date               CDATA #REQUIRED
    latitude           CDATA #REQUIRED
    longitude          CDATA #REQUIRED
    altitude           CDATA #REQUIRED
    horizontalAccuracy CDATA #REQUIRED
    verticalAccuracy   CDATA #REQUIRED
    course             CDATA #REQUIRED
    speed              CDATA #REQUIRED
  >
  <!ELEMENT ActivitySummary EMPTY>
  <!ATTLIST ActivitySummary
    dateComponents           CDATA #IMPLIED
    activeEnergyBurned       CDATA #IMPLIED
    activeEnergyBurnedGoal   CDATA #IMPLIED
    activeEnergyBurnedUnit   CDATA #IMPLIED
    appleExerciseTime        CDATA #IMPLIED
    appleExerciseTimeGoal    CDATA #IMPLIED
    appleStandHours          CDATA #IMPLIED
    appleStandHoursGoal      CDATA #IMPLIED
  >
  <!ELEMENT MetadataEntry EMPTY>
  <!ATTLIST MetadataEntry
    key   CDATA #REQUIRED
    value CDATA #REQUIRED
  >
  <!-- Note: Heart Rate Variability records captured by Apple Watch may include an associated list of instantaneous beats-per-minute readings. -->
  <!ELEMENT HeartRateVariabilityMetadataList (InstantaneousBeatsPerMinute*)>
  <!ELEMENT InstantaneousBeatsPerMinute EMPTY>
  <!ATTLIST InstantaneousBeatsPerMinute
    bpm  CDATA #REQUIRED
    time CDATA #REQUIRED
  >
  ]>
  <HealthData locale="en_US">
  PREAMBLE

  task :apple, [:user_id] => [:environment] do |_t, args|

    user = User.where(id: args[:user_id]).first
    unless user
      puts 'No user ID'
      exit
    end

    puts "Exporting for #{user.name}"

    File.open Rails.root.join('tmp', "export_#{Time.zone.now.to_s :number}.xml"), 'w' do |file|

      file.write preamble

      file.write "  <ExportDate value=\"#{Time.zone.now}\"/>\n"
      file.write "  <Me HKCharacteristicTypeIdentifierDateOfBirth=\"\" HKCharacteristicTypeIdentifierBiologicalSex=\"HKBiologicalSexNotSet\" HKCharacteristicTypeIdentifierBloodType=\"HKBloodTypeNotSet\" HKCharacteristicTypeIdentifierFitzpatrickSkinType=\"HKFitzpatrickSkinTypeNotSet\"/>\n"

      user.weights.find_each do |weight|
        file.write "  <Record type=\"HKQuantityTypeIdentifierBodyMass\" sourceName=\"Stardate\" sourceVersion=\"1\" unit=\"lb\" creationDate=\"#{weight.created_at}\" startDate=\"#{weight.export_start_at}\" endDate=\"#{weight.export_start_at}\" value=\"#{weight.weight}\"/>\n"
      end

      user.workouts.run.where.not(minutes: nil).find_each do |run|
        file.write "  <Record type=\"HKQuantityTypeIdentifierDistanceWalkingRunning\" sourceName=\"Stardate\" sourceVersion=\"1\" unit=\"mi\" creationDate=\"#{run.created_at}\" startDate=\"#{run.export_start_at}\" endDate=\"#{run.export_end_at}\" value=\"#{run.distance}\"/>\n"
      end

      user.workouts.bike.where.not(minutes: nil).find_each do |run|
        file.write "  <Record type=\"HKQuantityTypeIdentifierDistanceCycling\" sourceName=\"Stardate\" sourceVersion=\"1\" unit=\"mi\" creationDate=\"#{run.created_at}\" startDate=\"#{run.export_start_at}\" endDate=\"#{run.export_end_at}\" value=\"#{run.distance}\"/>\n"
      end

      file.write "</HealthData>"

    end
  end

end
