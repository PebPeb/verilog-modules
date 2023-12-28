from nmutil.gtkw import write_gtkw    # pip3 install libresoc-nmutil
import re
import os

GTKW_FILE = "uart_tb.gtkw"
VCD_FILE = "uart_tb.vcd"

SPACE = ({'comment': ''})


trace = [
  'uart_tb.clk',
  'uart_tb.reset',
  SPACE,
  ('States', [
    ('uart_tb.rx_DUT.state_reg[2:0]', {'display': 'RX State'}),
    ('uart_tb.tx_DUT.state_reg[2:0]', {'display': 'TX State'}),
  ]),
  ({'comment': 'UART TX'}),
  ('TX', [
    ('uart_tb.data[7:0]', {'display': 'TX Data'}),
    ('uart_tb.tx', {'display': 'TX Serial'}),
    ('uart_tb.tx_busy', {'display': 'TX Busy'}),
    ('uart_tb.tx_start', {'display': 'TX Trigger'}),
  ]),
  ({'comment': 'UART RX'}),
  ('RX', [
    ('uart_tb.rx_data[7:0]', {'display': 'RX Data'}),
    ('uart_tb.rx_busy', {'display': 'RX Busy'}),
    ('uart_tb.rx_valid', {'display': 'RX Valid'}),
  ]),
  ]

# ({'comment': 'UART RX'})
# ('uart_tb.clk', {'color': 'orange'}),

uart_state = {
  'title': 'uart_state',
  'states': [
    ('000', 'WAIT'),
    ('001', 'START'),
    ('010', 'DATA'),
    ('011', 'PARITY'),
    ('100', 'STOP'),
  ],
  'dir': ''
}



write_gtkw(GTKW_FILE, VCD_FILE, trace)



def gen_filter_file(data, rootdir=None):
  if rootdir == None:                                           # Set to absolute working dir
     rootdir = os.getcwd()    
  if not os.path.exists(rootdir + '/filters'):                  # Folder for filters                
    os.makedirs(rootdir + '/filters')

  # Set dir of filter file
  data['dir'] = rootdir + '/filters/' + data['title'] + ".filter"

  with open(data['dir'], 'w') as file:
    for state in data['states']:
      file.write(state[0] + ' ' + state[1] + '\n')


def apply_filter_file(data, net, filter):
  indent = 0
  for i in range(len(data)):
    if re.search(net, data[i + indent]):
      data.insert(i + indent, "@2028\n")
      indent = indent + 1
      data.insert(i + indent, "^1 " + filter['dir'] + "\n")
      indent = indent + 1
   
   

gen_filter_file(uart_state)

gtkw_data = open(GTKW_FILE, 'r').readlines()

search_for = [ 
  ("uart_tb.rx_DUT.state_reg", uart_state),
  ("uart_tb.tx_DUT.state_reg", uart_state)
]
for x in search_for: 
  apply_filter_file(gtkw_data, x[0], x[1])

# Write modified .gtkw file
with open(GTKW_FILE, 'w') as file:
    for item in gtkw_data:
        file.write(str(item))