require 'galerts'

manager = Galerts::Manager.new('example@gmail.com', 'password')

#   List alerts
alerts = manager.alerts
sample_alert = alerts.last

#   Create a new alert for on Google News Turkey in real time delivering alerts
#   via RSS
new_alert = manager.create("my keywords", {
  :frequency => Galerts::RT,
  :domain => 'com.tr',
  :language => "tr",
  :sources => [Galerts::NEWS],
  :how_many => Galerts::ALL_RESULTS,
  :region => "TR",
  :delivery => Galerts::RSS
  }
)

#   Update the query of this alert
sample_alert.query = "updated keyword"
manager.update(sample_alert)

#   Find examples
manager.find_by_query("keyword")
manager.find_by_delivery(Galerts::RSS)
manager.find({query: "keyword", delivery: Galerts::RSS})

#   Delete an alert
manager.delete(sample_alert)