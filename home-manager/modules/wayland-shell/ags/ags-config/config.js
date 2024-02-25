const date = Variable("", {
  poll: [1000, "date"],
});

const Bar = (monitor = 0) => Widget.Window({
  name: 'bar${monitor}',
  anchor : ["left" "top" "right"],
  child: Widget.Label({label: date.bind()})
})

export default {
  windows: [Bar(0)],
};
