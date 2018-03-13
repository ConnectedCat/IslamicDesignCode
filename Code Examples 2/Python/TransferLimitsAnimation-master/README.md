# Transfer Limits Animation
## Introduction
A set of Python functions that animates flows between power system areas. The time-varying flows are supplied in a csv-formatted input file organized as follows.

DateTime | FromArea | ToArea | Value
---------|----------|--------|-------
20170611 0:00 | NYISO | NEISO | 1000
20170611 0:00 | IESO | NYISO | 500
20170611 0:00 | NYISO | PJM | -500
20170611 0:00 | NEISO | HQ | -1000
20170611 0:00 | HQ | NYISO | 500
20170611 1:00 | NYISO | NEISO | 800
... |
20170611 1:00 | HQ | NYISO | 400

This example system has 5 areas:
1. NYISO - New York Independent System Operator http://www.nyiso.com/
1. NEISO - New England Independent System Operator http://www.iso-ne.com/
1. PJM - Pennsylvania Jersey Maryland System Operator
http://www.pjm.com
1. HQ - Hydro Quebec http://www.hydroquebec.com/international/en/
1. IESO - Independent System Operator Ontario http://www.ieso.ca/

The transfers between connected areas have time-dependent values and the input file supplies records of these transfers over time. The transfers can be recorded in two formats:
* **wide:** where rows are corresponding to time stamps and columns to pairs of areas with values of flow recorded in the table.
* **long:** where each row documents just one exchange value, resulting in time records repeating over multiple rows to capture values of flows between all connected areas.

The preference here is given to **long** format because the width of the records does not depend on the number of connected area pairs. The input files will be delivered in [hdf5 format](http://support.hdfgroup.org/HDF5/), and ingested into this tool using Python Data Analysis Library, the so-called [Pandas](http://pandas.pydata.org/). Pandas support computationally efficient **pivoting** (transformation of long format into wide) and **melting** (transformation of wide into long format). The compressed HDF5 format is more size-efficent when it deals with fixed record widths.
