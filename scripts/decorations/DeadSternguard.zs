class DeadSternguard: Actor Replaces DeadMarine
{
  Default{
	Scale 0.4;
  }
  States
  {
  Spawn:
    STND C -1;
    Stop;
  }
}