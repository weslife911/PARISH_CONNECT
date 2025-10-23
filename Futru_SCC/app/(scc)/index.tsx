import NoRecords from "@/components/SCC/NoRecords";
import RecordTab from "@/components/SCC/RecordTab";
import { Image, Text, View } from "react-native"

function SCCRecordsPage() {

  const testArray = [
    "a",
    "b"
  ];

  return (
    (testArray.length === 0 ? <NoRecords/> : <View>
      <RecordTab/>
    </View>)
  )
}

export default SCCRecordsPage