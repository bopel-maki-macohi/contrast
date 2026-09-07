package group;

class GroupObj extends Group<Obj>
{
	public function add(obj:Obj)
	{
		if (obj == null) return;

		if (list.indexOf(obj) > -1) return;

		list.push(obj);
	}

	public function remove(obj:Obj)
	{
		if (list.indexOf(obj) == -1) return;

		list.remove(obj);
	}
}
