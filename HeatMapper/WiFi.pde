import java.io.*;

int getWiFiStrength()
{
  String[] getWifiInfo={"/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport", "-I"};
  String[] shellOutput = runShellCommand(getWifiInfo);
  HashMap wifiProperties = parseWifiOutput(shellOutput);
  return Integer.parseInt((String) wifiProperties.get("agrCtlRSSI"));
}

HashMap<String, String> parseWifiOutput(String[] output)
{
  HashMap<String, String> outputparams = new HashMap<String, String>();
  for (int i=0; i < output.length; i++)
  {
    String line = output[i];
    line = line.trim();
    String[] parts = line.split(": ");
    outputparams.put(parts[0], parts[1]);
    printArray(parts);
  }
  return outputparams;
}

String[] runShellCommand(String[] cmds) {
  ArrayList<String> lines = new ArrayList<String>();
  Process process=exec(cmds);
  InputStream stdout=process.getInputStream();
  BufferedReader reader=new BufferedReader(new InputStreamReader(stdout));
  try {
    String line;
    while ((line=reader.readLine())!=null) {
      lines.add(line);
      println(line);
    }
  }
  catch(Exception e) {
    println(e);
  }
  return lines.toArray(new String[lines.size()]);
}
