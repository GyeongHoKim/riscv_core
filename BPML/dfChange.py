import pandas as pd

def changePC(df):
  currentIdx = df.index.to_list()
  currentLength = len(currentIdx)
  cols = []
  cols2 = []
  GAs = []
  for i in range(48):
    GAs.append('GA' + str(i))
  df['pc'] = [0 for _ in range(currentLength)]
  df[GAs] = pd.DataFrame([[0] * len(GAs)], index = df.index)

  for i in range(32):
    cols.append('pc' + str(31 - i))
  for i in range(48):
    for j in range(8):
      cols2.append('ga' + str(i) + 'x' + str(7 - j))
  
  for i in currentIdx:
    for j in range(len(cols)):
      df.loc[i, 'pc'] += df.loc[i, cols[j]] * (2 ** (31 - j))
    for j in range(48):
      name = 'GA' + str(j)
      for k in range(8):
        df.loc[i, name] += df.loc[i, cols2[j * 8 + k]] * (2 ** (7 - k))
  df.drop(labels = cols, axis = 1, inplace = True)
  df.drop(labels = cols2, axis = 1, inplace = True)
  return df

def addLastBT(df):
  currentIdx = df.index.to_list()
  currentLength = len(currentIdx)
  df['LastBT'] = [0 for _ in range(currentLength)]
  count = 0
  for i in currentIdx:
    count += 1
    if df.loc[i, 'bt'] == 1:
      count = 0
    df.loc[i, 'LastBT'] = count
  return df

def floatToInt(df):
  currentIdx = df.index.to_list()
  currentLength = len(currentIdx)
  df['clk'] = [0 for _ in range(currentLength)]
  df['BT'] = [0 for _ in range(currentLength)]

  for i in currentIdx:
    df.loc[i, 'clk'] = int(df.loc[i, 'clock'])
    df.loc[i, 'BT'] = int(df.loc[i, 'bt'])
  df.drop(labels = ['clock', 'bt'], axis = 1, inplace = True)
  return df

def rearrangeDF(df):
  return floatToInt(addLastBT(changePC(df)))
